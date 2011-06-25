class CreateMonitors < ActiveRecord::Migration
  def self.up
    create_table :monitors do |t|
      t.string :type
      t.string :size
      t.string :brand
      t.string :serial

      t.timestamps
    end
  end

  def self.down
    drop_table :monitors
  end
end
