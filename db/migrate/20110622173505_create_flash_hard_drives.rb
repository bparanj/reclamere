class CreateFlashHardDrives < ActiveRecord::Migration
  def self.up
    create_table :flash_hard_drives do |t|
      t.string :brand
      t.string :serial

      t.timestamps
    end
  end

  def self.down
    drop_table :flash_hard_drives
  end
end
