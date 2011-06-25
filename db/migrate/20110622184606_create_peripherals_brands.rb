class CreatePeripheralsBrands < ActiveRecord::Migration
  def self.up
    create_table :peripherals_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :peripherals_brands
  end
end
