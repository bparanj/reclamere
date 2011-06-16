class RemoveDescriptionFromFolders < ActiveRecord::Migration
  def self.up
    remove_column :folders, :description
  end

  def self.down
    add_column :folders, :description, :string
  end
end
