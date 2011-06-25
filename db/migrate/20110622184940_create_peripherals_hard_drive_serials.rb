class CreatePeripheralsHardDriveSerials < ActiveRecord::Migration
  def self.up
    create_table :peripherals_hard_drive_serials do |t|
      t.string :name
      t.references :peripherals
      
      t.timestamps
    end
  end

  def self.down
    drop_table :peripherals_hard_drive_serials
  end
end
