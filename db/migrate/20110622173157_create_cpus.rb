class CreateCpus < ActiveRecord::Migration
  def self.up
    create_table :cpus do |t|
      t.string :cpu_type
      t.string :brand
      t.string :serial
      t.string :cpu_class

      t.timestamps
    end
  end

  def self.down
    drop_table :cpus
  end
end
