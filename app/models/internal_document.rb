class InternalDocument < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :user
    
  # TODO : Check allowed file extensions
  # Delete functionality
  # List file names in index action
  # Allow download and deleting files
  
  def self.save(upload, user_id, pickup_id)
    name =  upload['datafile'].original_filename
    file_name = sanitize_filename(name)
    create(:name => file_name, :user_id => user_id, :pickup_id => pickup_id)
    # create the file path
    path = File.join(STORAGE_FOLDER, file_name)
    # write the file
    File.open(path, "wb") do |f| 
      f.write(upload['datafile'].read) 
    end
  end
  
  def self.sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids
    # with underscore
    just_filename.sub(/[^\w\.\-]/,'_') 
  end
  
  def cleanup
    f = "#{RAILS_ROOT}/dirname/#{@filename}"
    File.delete(f) if File.exist?(f)
  end
  
end
