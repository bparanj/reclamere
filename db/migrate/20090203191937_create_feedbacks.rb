class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :pickup_id, :null => false
      t.integer :client_user_id, :null => false
      t.string :value, :null => false, :limit => 40
      t.integer :complete, :null => false, :limit => 1, :default => 0
      t.integer :contacted_promptly, :limit => 1
      t.integer :complete_audit_timely, :limit => 1
      t.integer :appropriate_communication, :limit => 1
      t.integer :customer_service_needs, :limit => 1
      t.text :comments
      t.integer :solution_owner_contact, :limit => 1
      t.text :references
      t.integer :updated_by_id
      t.datetime :updated_at
    end
    add_index :feedbacks, :pickup_id
    add_index :feedbacks, :client_user_id
    add_index :feedbacks, :value, :unique => true
  end

  def self.down
    drop_table :feedbacks
  end
end
