class Document < ActiveRecord::Base
  attr_protected :version, :filename, :content_type, :size, :root_folder_id, :sha1

  version_fu do
    belongs_to :created_by,
      :class_name => '::User',
      :foreign_key => :created_by_id

    after_destroy :destroy_file

    def absolute_filename
      Document.absolute_filename(sha1)
    end
    
    def file_exist?
      absolute_filename && File.exist?(absolute_filename)
    end

    protected

    def destroy_file
      FileUtils.rm(absolute_filename) if file_exist?
      Document.remove_empty_dir(absolute_filename)
    end
  end

  belongs_to :folder
  belongs_to :root_folder,
    :class_name => 'Folder',
    :foreign_key => 'root_folder_id'
  belongs_to :created_by,
    :class_name => 'User',
    :foreign_key => 'created_by_id'

  validates_presence_of :folder_id, :root_folder_id, :name, :filename, :version,
    :content_type, :size, :sha1, :created_by_id
  validates_length_of :name, :within => 1..255
  validates_length_of :filename, :within => 1..255
  validates_length_of :size, :minimum => 1
  validates_length_of :sha1, :is => 40
  validates_uniqueness_of :name, :scope => :folder_id

  before_validation :set_root_folder
  after_save :save_file
  after_destroy :destroy_file

  def content
    return @content if defined?(@content)
    if file_exist?
      @content = File.read(absolute_filename)
    end
  end

  def safe_content
    if file_exist?
      # replace all non-printable characters with a space
      %x{ cat "#{to_path}" | tr -c '\11\12\40-\176' '\40' }.strip
    end
  end

  def content=(c)
    self.sha1 = Digest::SHA1.hexdigest(c)
    self.size = c.bytesize
    @content = c
  end

  # Shell safe way to update the content of a file with a path to the file.
  def content_file=(file_path)
    if File.exist?(file_path)
      s = File.size(file_path)
      if s > 0
        self.size = s
        self.content_type = %x[ file -ib "#{file_path}" ].strip
        self.filename = File.basename(file_path)
        self.content = File.read(file_path)
        true
      else
        false
      end
    else
      false
    end
  end

  def absolute_filename
    self.class.absolute_filename(sha1)
  end
  alias_method :to_path, :absolute_filename

  def self.absolute_filename(sha1)
    if sha1.is_a?(String) && sha1.length == 40
      File.join(AppUtils.storage('document', sha1[0..1]), sha1[2..39])
    else
      nil
    end
  end

  def file_exist?
    absolute_filename && !!File.size?(absolute_filename)
  end

  def uploaded_data=(file_data)
    return nil if file_data.nil? || file_data.size == 0
    self.size = file_data.size
    self.content_type = file_data.content_type
    self.filename = file_data.original_filename
    if file_data.is_a?(StringIO)
      file_data.rewind
      self.content = file_data.read
    else
      self.content = File.read(file_data.path)
    end
    true
  end

  # Overridden rom version-fu
  def create_new_version?
    absolute_filename && !File.exist?(absolute_filename)
  end

  def self.remove_empty_dir(file_path)
    dir = File.dirname(file_path)
    if File.directory?(dir) && dir.match(/\/[0-9a-z]{2,2}$/)
      if (Dir.entries(dir) - ['.','..']).length == 0
        FileUtils.rmdir(dir)
      end
    end
  end

  protected

  def set_root_folder
    if folder.is_a?(Folder)
      self.root_folder = folder.root
    end
  end

  def save_file
    if absolute_filename && !File.exist?(absolute_filename)
      if content.nil? || content == ''
        raise ActiveRecord::Rollback
      else
        File.open(absolute_filename, 'w') { |f| f << content }
      end
    end
    unless file_exist?
      raise ActiveRecord::Rollback
    end
  end

  def destroy_file
    FileUtils.rm(absolute_filename) if file_exist?
    self.class.remove_empty_dir(absolute_filename)
    true
  end

end
