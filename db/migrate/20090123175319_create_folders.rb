class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.integer :folderable_id, :null => false
      t.string :folderable_type, :null => false
      t.integer :parent_id
      t.integer :root_folder_id
      t.string :name, :null => false
      t.string :description
    end
    # add_index :folders, [ :folderable_id, :folderable_type ], :name => :index_folderable
    # add_index :folders, [ :parent_id, :name ], :name => :index_name, :unique => true
    # add_index :folders, :root_folder_id, :name => :index_root_folder
  end

  def self.down
    drop_table :folders
  end
end
