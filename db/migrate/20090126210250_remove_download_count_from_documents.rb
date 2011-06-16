class RemoveDownloadCountFromDocuments < ActiveRecord::Migration
  def self.up
    remove_column :documents, :downloads
  end

  def self.down
    add_column :documents, :downloads, :integer, :null => false, :default => 0
  end
end
