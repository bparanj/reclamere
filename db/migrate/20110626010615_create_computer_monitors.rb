class CreateComputerMonitors < ActiveRecord::Migration
  def self.up
    create_table :computer_monitors do |t|
      t.string :cm_type
      t.string :size
      t.string :brand
      t.string :serial

      t.timestamps
    end
    
  end

  def self.down
    drop_table :computer_monitors
  end
end
