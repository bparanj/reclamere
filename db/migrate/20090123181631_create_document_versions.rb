class CreateDocumentVersions < ActiveRecord::Migration
  def self.up
    create_table :document_versions do |t|
      t.integer :document_id, :null => false
      t.string :name, :null => false
      t.string :description
      t.integer :version, :null => false, :default => 1
      t.string :filename, :null => false
      t.string :sha1, :null => false, :limit => 40
      t.string :content_type, :null => false
      t.integer :size, :null => false
      t.datetime :created_at, :null => false
      t.integer :created_by_id, :null => false
    end
    add_index :document_versions, :document_id
  end

  def self.down
    drop_table :document_versions
  end
end
