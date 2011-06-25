class CreateMiscellaneousEquipmentTypes < ActiveRecord::Migration
  def self.up
    create_table :miscellaneous_equipment_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :miscellaneous_equipment_types
  end
end
