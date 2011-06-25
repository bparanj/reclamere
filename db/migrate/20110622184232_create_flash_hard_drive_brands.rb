class CreateFlashHardDriveBrands < ActiveRecord::Migration
  def self.up
    create_table :flash_hard_drive_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :flash_hard_drive_brands
  end
end
