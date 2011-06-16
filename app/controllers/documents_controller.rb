class DocumentsController < ApplicationController
  before_filter :solution_owner_user_required, :except => [ :show, :download, :versions ]
  before_filter :get_folders
  before_filter :get_document, :except => [ :new, :create ]
  helper :folders

  # GET /documents/1
  # GET /documents/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = @folder.documents.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.xml
  def create
    @document = Document.new(params[:document].merge({ :created_by => current_user }))
    @document.folder = @folder unless @document.folder
    respond_to do |format|
      if @document.save
        donemessage 'Success!', "Document \"#{@document.name}\" was successfully created."
        audit "Created document \"#{@document.name}\"", :auditable => @folderable
        format.html { redirect_to polymorphic_path([@folderable, @document.folder]) }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        format.html do
          render :action => "new"
        end
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    respond_to do |format|
      @document.attributes = params[:document]
      if @document.create_new_version?
        @document.created_by = current_user
      end
      @document.folder = @folder unless @document.folder
      if @document.save
        donemark "Document \"#{@document.name}\" was successfully updated."
        audit "Updated document \"#{@document.name}\"", :auditable => @folderable
        format.html { redirect_to polymorphic_path([@folderable, @document.folder, @document]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document.destroy
    donemark "Document \"#{@document.name}\" was deleted successfully."
    audit "Deleted document \"#{@document.name}\"", :auditable => @folderable
    respond_to do |format|
      format.html { redirect_to polymorphic_path([@folderable, @document.folder]) }
      format.xml  { head :ok }
    end
  end

  # download document
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

  # show document versions
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
