class CreateMonitorBrands < ActiveRecord::Migration
  def self.up
    create_table :monitor_brands do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :monitor_brands
  end
end
