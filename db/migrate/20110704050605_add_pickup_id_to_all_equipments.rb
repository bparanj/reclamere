class AddPickupIdToAllEquipments < ActiveRecord::Migration
  def self.up
    add_column(:computer_monitors, :pickup_id, :integer)
    add_column(:cpus, :pickup_id, :integer)
    add_column(:loose_hard_drives, :pickup_id, :integer)
    add_column(:flash_hard_drives, :pickup_id, :integer)
    add_column(:tvs, :pickup_id, :integer)
    add_column(:magnetic_medias, :pickup_id, :integer)
    add_column(:peripherals, :pickup_id, :integer)
    add_column(:miscellaneous_equipments, :pickup_id, :integer)
  end

  def self.down
  end
end