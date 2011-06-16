class UpdatePickupDates < ActiveRecord::Migration
  def self.up
    # change_column :pickups, :pickup_date, :date, :null => true
    # change_column :pickups, :notification_date, :date, :null => true
    # change_column :pickups, :name, :string, :null => true
    # add_column :pickups, :pickup_date_range, :string
  end

  def self.down
    change_column :pickups, :pickup_date, :date, :null => false
    change_column :pickups, :notification_date, :date, :null => false
    change_column :pickups, :name, :string, :null => false
    remove_column :pickups, :pickup_date_range
  end
end
