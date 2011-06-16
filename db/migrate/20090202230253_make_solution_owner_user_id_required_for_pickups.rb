class MakeSolutionOwnerUserIdRequiredForPickups < ActiveRecord::Migration
  def self.up
    change_column :pickups, :solution_owner_user_id, :integer, :null => false
  end

  def self.down
    change_column :pickups, :solution_owner_user_id, :integer, :null => true
  end
end
