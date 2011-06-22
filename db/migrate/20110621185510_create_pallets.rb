class CreatePallets < ActiveRecord::Migration
  def self.up
    create_table :pallets do |t|
      t.string :number
      t.text :description
      t.string :weight
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :pallets
  end
end
