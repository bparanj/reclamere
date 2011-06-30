class AddLotNumberToPickup < ActiveRecord::Migration
  def self.up
    add_column(:pickups, :lot_number, :string)
  end

  def self.down
    remove_column(:pickups, :lot_number)
  end
end
