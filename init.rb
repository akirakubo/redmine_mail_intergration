Redmine::Plugin.register :redmine_mail_intergration do
  name 'Redmine mail intergration plugin'
  author 'Yusuke Kokubo'
  description 'more mail intergration than redmine receive email.'
  version '0.0.1'

  requires_redmine :version_or_higher => '1.2.0'
end

Rails.configuration.to_prepare do
  require_dependency 'mail_handler'

  unless MailHandler.included_modules.include? RedmineMailIntergration::MailHandlerPatch
    MailHandler.send(:include, RedmineMailIntergration::MailHandlerPatch)
  end
end
