class CreateTvBrands < ActiveRecord::Migration
  def self.up
    create_table :tv_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tv_brands
  end
end
