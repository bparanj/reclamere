class CreateMiscellaneousEquipmentBrands < ActiveRecord::Migration
  def self.up
    create_table :miscellaneous_equipment_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :miscellaneous_equipment_brands
  end
end
