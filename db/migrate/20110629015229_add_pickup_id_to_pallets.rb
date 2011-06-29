class AddPickupIdToPallets < ActiveRecord::Migration
  def self.up
    add_column(:pallets, :pickup_id, :integer)
  end

  def self.down
    remove_column(:pallets, :pickup_id)
  end
end
