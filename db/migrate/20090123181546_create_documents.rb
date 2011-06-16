class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.integer :folder_id, :null => false
      t.integer :root_folder_id, :null => false
      t.string :name, :null => false
      t.string :description
      t.integer :version, :null => false, :default => 1
      t.string :filename, :null => false
      t.string :sha1, :null => false, :limit => 40
      t.string :content_type, :null => false
      t.integer :size, :null => false
      t.integer :downloads, :null => false, :default => 0
      t.datetime :created_at, :null => false
      t.integer :created_by_id, :null => false
    end
    add_index :documents, :folder_id
    add_index :documents, :root_folder_id
  end

  def self.down
    drop_table :documents
  end
end
