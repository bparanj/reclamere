class CreateMiscellaneousEquipments < ActiveRecord::Migration
  def self.up
    create_table :miscellaneous_equipments do |t|
      t.string :serial
      t.string :type
      t.string :brand
      
      t.timestamps
    end
  end

  def self.down
    drop_table :miscellaneous_equipments
  end
end
