class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :type, :string, :null => false
      t.column :client_id, :integer
      t.column :login, :string, :null => false
      t.column :email, :string, :null => false

      t.column :name, :string, :null => false
      t.column :title, :string
      t.column :phone, :string
      
      t.column :time_zone, :string
      t.column :last_login, :datetime
      t.column :breadcrumbs, :text

      t.column :admin, :integer, :limit => 1, :null => false, :default => 0
      t.column :inactive, :integer, :limit => 1, :null => false, :default => 0

      t.column :crypted_password, :string, :limit => 40
      t.column :salt, :string, :limit => 40
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :remember_token, :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
    end

    add_index :users, :type
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
