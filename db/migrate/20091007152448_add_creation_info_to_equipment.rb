class AddCreationInfoToEquipment < ActiveRecord::Migration
  def self.up
    add_column :equipment, :created_at, :datetime
    add_column :equipment, :created_by_id, :integer
  end

  def self.down
    remove_column :equipment, :created_at
    remove_column :equipment, :created_by_id
  end
end
