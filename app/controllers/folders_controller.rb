class FoldersController < ApplicationController
  before_filter :solution_owner_user_required, :except => [ :index, :folder_contents, :show ]
  before_filter :get_folders

  def index
    @new_folder = Folder.new({ :parent => @folder })
    @document = @folder.documents.new
    get_documents_list

    render :xml => @root_folder.folder_tree 
  end

  def folder_contents
    @new_folder = Folder.new({ :parent => @folder })
    @document = @folder.documents.new
    get_documents_list
    
    render :partial => 'folder_contents', :layout => false
  end

  def show
    @new_folder = Folder.new({ :parent => @folder })
    @document = @folder.documents.new
    @pickup = Pickup.find(params[:pickup_id])
        
    get_documents_list
    
    render :action => 'index'
  end

  def create
    @new_folder = Folder.new(params[:new_folder])
    @new_folder.parent = @folder unless @new_folder.parent
    
    if @new_folder.save
      donemark "Folder \"#{@new_folder.name}\" was successfully created."
      audit 'Created folder: ' + @new_folder.name, :auditable => @folderable
      redirect_to polymorphic_path([@folderable, @new_folder]) 
    else
      @show_new_folder = true
      @document = @folder.documents.new
      get_documents_list
      render :action => "index", :id => @folder.id
    end
  end

  def update
    if @folder.root?
      access_denied("You cannot edit the root folder.")
    else
      if @folder.update_attributes(params[:folder])
        donemark "Folder \"#{@folder.name}\" was successfully updated."
        audit 'Updated folder: ' + @folder.name, :auditable => @folderable
        redirect_to polymorphic_path([@folderable, @folder])
      else
        @show_edit_folder = true
        get_documents_list
        render :action => "index", :id => @folder.id
      end
    end
  end

  def destroy
    if @folder.root?
      errormark "You cannot delete the root folder."
      @show_edit_folder = true
      redirect_to polymorphic_path([@folderable, @folder])
    else
      @folder.destroy
      donemark "Successfully deleted folder: \"#{@folder.name}\"."
      audit "Deleted folder: \"#{@folder.name}\"", :auditable => @folderable
      redirect_to polymorphic_path([@folderable, @folder.parent]) 
    end
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
    @folder = params[:id] ? @folderable.folders.find(params[:id]) : @root_folder
  end

  def get_documents_list
    name = :"#{@folderable.class.name.downcase.pluralize}/#{@folderable.id}/folders/#{@folder.id}"
    @list_nav = ListNav.new(params, list_nav(:name => name),
      { :default_sort_field => 'name',
        :default_sort_direction => 'ASC',
        :limit => PER_PAGE })
    @list_nav.count = @folder.documents.count(:conditions => @list_nav.conditions, :include => :created_by)
    @documents = @folder.documents.all(
      :include    => :created_by,
      :conditions => @list_nav.conditions,
      :order      => @list_nav.order,
      :limit      => @list_nav.limit,
      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash.merge({ :name => name })
  end
end
