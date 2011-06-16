class AddDefaultPickupLocationSolutionOwnerLead < ActiveRecord::Migration
  def self.up
    add_column :pickup_locations, :solution_owner_user_id, :integer
  end

  def self.down
    remove_column :pickup_locations, :solution_owner_user_id
  end
end
