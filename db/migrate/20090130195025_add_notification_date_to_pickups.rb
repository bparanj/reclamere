class AddNotificationDateToPickups < ActiveRecord::Migration
  def self.up
    # add_column :pickups, :notification_date, :date, :null => false
    # add_index :pickups, :notification_date
  end

  def self.down
    # remove_column :pickups, :notification_date
  end
end
