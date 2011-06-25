class CreateTvs < ActiveRecord::Migration
  def self.up
    create_table :tvs do |t|
      t.string :brand
      t.string :size
      t.string :serial

      t.timestamps
    end
  end

  def self.down
    drop_table :tvs
  end
end
