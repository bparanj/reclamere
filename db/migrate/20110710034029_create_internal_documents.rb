class CreateInternalDocuments < ActiveRecord::Migration
  def self.up
    create_table :internal_documents do |t|
      t.integer  :pickup_id,     :null => false
      t.string   :name,          :null => false
      t.integer  :user_id,       :null => false
      t.string   :filename,      :null => false
      t.string   :content_type,  :null => false
      t.integer  :size,          :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :internal_documents
  end
end