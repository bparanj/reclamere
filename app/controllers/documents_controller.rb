class DocumentsController < ApplicationController
  before_filter :solution_owner_user_required, :except => [ :show, :download, :versions ]
  before_filter :get_folders
  before_filter :get_document, :except => [ :new, :create ]
  helper :folders

  def show
  end

  def new
    @document = @folder.documents.new
  end

  def edit
  end

  def create
    @document = Document.new(params[:document].merge({ :created_by => current_user }))
    @document.folder = @folder unless @document.folder
    
    if @document.save
      donemessage 'Success!', "Document \"#{@document.name}\" was successfully created."
      audit "Created document \"#{@document.name}\"", :auditable => @folderable
      redirect_to polymorphic_path([@folderable, @document.folder])
    else
      render :action => "new"
    end
  end

  def update
    @document.attributes = params[:document]
    if @document.create_new_version?
      @document.created_by = current_user
    end
    @document.folder = @folder unless @document.folder
    if @document.save
      donemark "Document \"#{@document.name}\" was successfully updated."
      audit "Updated document \"#{@document.name}\"", :auditable => @folderable
      redirect_to polymorphic_path([@folderable, @document.folder, @document])
    else
      render :action => "edit"
    end
  end

  def destroy
    @document.destroy
    donemark "Document \"#{@document.name}\" was deleted successfully."
    audit "Deleted document \"#{@document.name}\"", :auditable => @folderable
    
    redirect_to polymorphic_path([@folderable, @document.folder])    
  end

  def download
    if params[:version]
      document = @document.versions.find(params[:version])
    else
      document = @document
    end
    if document.file_exist?
      send_file(document.absolute_filename,
        :filename => document.filename,
        :type => document.content_type,
        :disposition => 'attachment',
        :streaming => true)
    else
      errormark "Sorry, unable to retrieve this file at this time. Please try again later."
      redirect_to polymorphic_path([@folderable, @document.folder, @document])
    end
  end

  def versions
    @versions = @document.versions.find(:all, :order => 'version DESC')
  end

  private

  def get_folders
    if params[:client_id]
      @folderable = Client.find(params[:client_id])
      if client_user? && (@folderable != @client || !admin?)
        access_denied
      end
    elsif params[:pickup_id]
      @folderable = Pickup.find(params[:pickup_id])
      if client_user? && @folderable.client != @client
        access_denied
      end
    end
    @root_folder = @folderable.root_folder
    @folder = params[:folder_id] ? @folderable.folders.find(params[:folder_id]) : @root_folder
  end

  def get_document
    @document = @folder.documents.find(params[:id])
    current_user.add_breadcrumb(@document.name, polymorphic_path([@folderable, @folder, @document]))
  end

end
