class CreateMailMessages < ActiveRecord::Migration
  def change
    create_table :mail_messages do |t|
      t.string :message_id, :null => false
      t.integer :issue_id, :null => false
      t.string :username
    end
  end
end
