class CreatePeripherals < ActiveRecord::Migration
  def self.up
    create_table :peripherals do |t|
      t.string :type
      t.string :brand
      t.string :serial

      t.timestamps
    end
  end

  def self.down
    drop_table :peripherals
  end
end
