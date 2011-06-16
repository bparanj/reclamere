class AddAttrsToEquipment < ActiveRecord::Migration
  def self.up
    add_column :equipment, :disposition, :string
    add_column :equipment, :customer, :string
    add_column :equipment, :asset_tag, :string
  end

  def self.down
    remove_column :equipment, :disposition
    remove_column :equipment, :customer
    remove_column :equipment, :asset_tag
  end
end
