class CreateCpuBrands < ActiveRecord::Migration
  def self.up
    create_table :cpu_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :cpu_brands
  end
end
