class CreatePickups < ActiveRecord::Migration
  def self.up
    create_table :pickups do |t|
      t.integer :pickup_location_id, :null => false
      t.integer :client_id, :null => false
      t.string :name, :null => true
      t.string :status, :null => false
      t.string :pickup_type, :null => false
      t.string :special_request
      t.string :quantity
      t.date :pickup_date, :null => true
      t.string :pickup_time
      t.string :site_contact_name
      t.string :client_reference
      t.integer :solution_owner_user_id
      t.integer :client_user_id
      t.integer :created_by_id
      t.datetime :created_at
      t.date :notification_date, :null => true
      t.string :pickup_date_range
      
    end
    
    add_index :pickups, :pickup_location_id
    add_index :pickups, :client_id
    add_index :pickups, :name
    add_index :pickups, :status
    add_index :pickups, :pickup_type
    add_index :pickups, :pickup_date
    add_index :pickups, :notification_date
  end

  def self.down
    drop_table :pickups
  end
end
