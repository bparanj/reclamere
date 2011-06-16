class UpdateEquipmentSerial < ActiveRecord::Migration
  def self.up
    change_column :equipment, :serial, :string, :null => true
    remove_index :equipment, :serial
    add_index :equipment, :serial
  end

  def self.down
    change_column :equipment, :serial, :string, :null => false
    remove_index :equipment, :serial
    add_index :equipment, :serial, :unique => true
  end
end
