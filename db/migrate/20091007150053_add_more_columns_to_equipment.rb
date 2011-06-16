class AddMoreColumnsToEquipment < ActiveRecord::Migration
  COLUMNS = [:country, :location, :piu, :dws_cart, :cpu, :monitors, :bob, :bob_cable]
  def self.up
    COLUMNS.each do |m|
      add_column :equipment, m, :string
    end
  end

  def self.down
    COLUMNS.each do |m|
      remove_column :equipment, m
    end
  end
end
