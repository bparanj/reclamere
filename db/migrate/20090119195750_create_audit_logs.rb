class CreateAuditLogs < ActiveRecord::Migration
  def self.up
    create_table :audit_logs do |t|
      t.integer :user_id, :null => false
      t.string :request_uri, :null => false
      t.string :remote_addr, :null => false
      t.string :description, :null => false
      t.datetime :created_at, :null => false
      t.string :auditable_type
      t.integer :auditable_id
    end
    add_index :audit_logs, :user_id
  end

  def self.down
    drop_table :audit_logs
  end
end
