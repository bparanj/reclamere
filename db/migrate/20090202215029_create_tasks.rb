class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer :pickup_id, :null => false
      t.integer :num, :limit => 1, :null => false
      t.string :name, :null => false
      t.string :status, :null => false
      t.string :comments
      t.datetime :updated_at
      t.integer :solution_owner_user_id
    end
    add_index :tasks, :pickup_id
    add_index :tasks, :num
    add_index :tasks, :name
    add_index :tasks, :status
  end

  def self.down
    drop_table :tasks
  end
end
