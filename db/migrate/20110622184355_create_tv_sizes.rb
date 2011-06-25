class CreateTvSizes < ActiveRecord::Migration
  def self.up
    create_table :tv_sizes do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tv_sizes
  end
end
