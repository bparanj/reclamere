class CreateEquipment < ActiveRecord::Migration
  def self.up
    create_table :equipment do |t|
      t.string :type, :null => false
      t.string :type_name, :null => false
      t.integer :pickup_id, :null => false
      t.integer :client_id, :null => false
      t.string :tracking, :null => false
      t.string :serial, :null => false
      t.string :mfg
      t.string :model
      t.string :comments
      t.string :grade
      t.integer :recycling
      t.integer :value
      t.string :processor
      t.string :hard_drive
      t.string :ram
      t.integer :page_count
      t.string :screen_size
      t.string :mfg_date
    end
    add_index :equipment, :type
    add_index :equipment, :type_name
    add_index :equipment, :pickup_id
    add_index :equipment, :client_id
    add_index :equipment, :tracking, :unique => true
    add_index :equipment, :serial, :unique => true
  end

  def self.down
    drop_table :equipment
  end
end
