class InternalDocument < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :user
    
  # TODO : Check allowed file extensions
  # Delete functionality
  # List file names in index action
  # Allow download and deleting files

  def self.save(name, upload, user_id, pickup_id)
    original_file_name =  upload['datafile'].original_filename
    file_name = sanitize_filename(original_file_name)
    create_internal_document(name, file_name, user_id, pickup_id)
    path = create_file_path(file_name)
    write_file(upload, path)    
  end
  
  # def self.save(upload, user_id, pickup_id)
  #   name =  upload['datafile'].original_filename
  #   file_name = sanitize_filename(name)
  #   create(:name => file_name, :user_id => user_id, :pickup_id => pickup_id)
  #   
  #   # create the file path
  #   path = File.join(STORAGE_FOLDER, file_name)
  #   
  #   # write the file
  #   File.open(path, "wb") do |f| 
  #     f.write(upload['datafile'].read) 
  #   end
  # end
  
  def self.sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
  
  def delete_file
    f = "#{RAILS_ROOT}/#{STORAGE_FOLDER}/#{self.filename}"
    File.delete(f) if File.exist?(f)
  end
  
  
  private
  
  def self.create_file_path(file_name)
    File.join(STORAGE_FOLDER, file_name)
  end
  
  def self.write_file(upload, path)
    File.open(path, "wb") do |f| 
      f.write(upload['datafile'].read) 
    end    
  end
  
  def self.create_internal_document(name, file_name, user_id, pickup_id)    
    internal_doc = InternalDocument.new
    internal_doc.content_type = %x[ file -ib "#{STORAGE_FOLDER}" ].strip
    internal_doc.name = name
    internal_doc.filename = file_name
    internal_doc.user_id = user_id
    internal_doc.pickup_id = pickup_id
    internal_doc.size = File.size(STORAGE_FOLDER + "/#{file_name}")    
    internal_doc.save
  end
end
