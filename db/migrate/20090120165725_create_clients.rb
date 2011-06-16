class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.string :name, :null => false
      t.string :address_1, :null => false
      t.string :address_2
      t.string :city, :null => false
      t.string :state, :null => false, :limit => 2
      t.string :postal_code, :limit => 10
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
    end
    add_index :clients, :name, :unique => true
  end

  def self.down
    drop_table :clients
  end
end
