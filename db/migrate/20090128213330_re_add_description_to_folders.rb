class ReAddDescriptionToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :description, :string
  end

  def self.down
    remove_column :folders, :description
  end
end
