class CreatePickupLocations < ActiveRecord::Migration
  def self.up
    create_table :pickup_locations do |t|
      t.string :name, :null => false
      t.integer :client_id, :null => false
      t.integer :client_user_id
      t.string :address_1, :null => false
      t.string :address_2
      t.string :city, :null => false
      t.string :state, :null => false, :limit => 2
      t.string :postal_code, :limit => 10
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
    end
    add_index :pickup_locations, :name
    add_index :pickup_locations, :client_id
    add_index :pickup_locations, :client_user_id
  end

  def self.down
    drop_table :pickup_locations
  end
end
