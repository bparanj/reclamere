class CreateSystemEmails < ActiveRecord::Migration
  def self.up
    create_table :system_emails do |t|
      t.integer :pickup_id, :null => false
      t.integer :user_id, :null => false
      t.string :subject, :null => false
      t.text :body
      t.datetime :created_at
    end
    add_index :system_emails, :pickup_id
  end

  def self.down
    drop_table :system_emails
  end
end
