module RedmineMailIntergration
  module MailHandlerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
 
        alias_method_chain :dispatch, :more_intergration
      end
    end

    module InstanceMethods
      def dispatch_with_more_intergration
        # なぜかrakeタスクがここらへんの設定をしてくれないのでここで設定する
        @keywords ||= {}
        %w(project status tracker category priority).each {|a| @keywords[a.to_sym] = ENV[a] if ENV[a] }
        @keywords[:tracker] = Tracker.find(ENV['tracker_id']).name if ENV['tracker_id']

        if email.subject.to_s =~ %r{\[(?:[^\]]*\s+)?#(\d+)\]} and Issue.find_by_id($1.to_i)
          # replyの場合は注記したいだけなのでプロパティの変更は認めない
          @keywords = {}
          journal = receive_issue_reply($1.to_i)
          issue = journal.issue
        elsif email.subject.to_s =~ %r{\[[^\]]*msg(\d+)\]}
          dispatch_without_more_intergration
          return
        else
          unless email.in_reply_to or email.references
            issue = dispatch_to_default
            return unless issue
          else
            msg = MailMessage.find_by_message_id_and_username(email.in_reply_to, ENV['username'])
            msg = MailMessage.find_by_message_id_and_username(email.references, ENV['username']) unless msg

            if msg and Issue.find_by_id(msg.issue_id)
              journal = receive_issue_reply(msg.issue_id)
              issue = journal.issue
            else
              issue = dispatch_to_default
              return unless issue
            end
          end
        end

        msg = MailMessage.find_by_message_id_and_username(email.message_id, ENV['username']) || MailMessage.new
        msg.message_id = email.message_id
        msg.issue_id = issue.id
        msg.username = ENV['username']
        msg.save!
      end
    end
  end
end
