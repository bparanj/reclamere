class CreateMagneticMedias < ActiveRecord::Migration
  def self.up
    create_table :magnetic_medias do |t|
      t.string :mm_type
      t.string :weight

      t.timestamps
    end
  end

  def self.down
    drop_table :magnetic_medias
  end
end
