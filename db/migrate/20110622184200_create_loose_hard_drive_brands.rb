class CreateLooseHardDriveBrands < ActiveRecord::Migration
  def self.up
    create_table :loose_hard_drive_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :loose_hard_drive_brands
  end
end
