class MakePickupLocationDefaultClientUserRequired < ActiveRecord::Migration
  def self.up
    change_column :pickup_locations, :client_user_id, :integer, :null => false
    change_column :pickups, :client_user_id, :integer, :null => false
  end

  def self.down
    change_column :pickup_locations, :client_user_id, :integer, :null => true
    change_column :pickups, :client_user_id, :integer, :null => true
  end
end
