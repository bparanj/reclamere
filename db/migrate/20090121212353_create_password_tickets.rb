class CreatePasswordTickets < ActiveRecord::Migration
  def self.up
    create_table :password_tickets do |t|
      t.integer :user_id, :null => false
      t.string :value, :null => false, :limit => 40
      t.datetime :expires_at, :null => false
    end
    add_index :password_tickets, :user_id, :unique => true
    add_index :password_tickets, :value, :unique => true
  end

  def self.down
    drop_table :password_tickets
  end
end
