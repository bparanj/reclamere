class CreateCpuHardDriveSerials < ActiveRecord::Migration
  def self.up
    create_table :cpu_hard_drive_serials do |t|
      t.string :name
      t.references :cpu
      
      t.timestamps
    end
  end

  def self.down
    drop_table :cpu_hard_drive_serials
  end
end
