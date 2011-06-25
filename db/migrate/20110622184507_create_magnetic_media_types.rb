class CreateMagneticMediaTypes < ActiveRecord::Migration
  def self.up
    create_table :magnetic_media_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :magnetic_media_types
  end
end
