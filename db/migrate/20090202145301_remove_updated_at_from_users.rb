class RemoveUpdatedAtFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :updated_at
    change_column :pickups, :pickup_type, :string, :null => true
    remove_index :pickups, :pickup_type
  end

  def self.down
    #add_column :users, :updated_at, :datetime
    #change_column :pickups, :pickup_type, :string, :null => false
    add_index :pickups, :pickup_type
  end
end
