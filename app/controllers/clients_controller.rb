class ClientsController < ApplicationController
  before_filter :solution_owner_user_required
  before_filter :solution_owner_admin_required, :only => [ :new, :edit, :create, :update ]
  helper :google_maps

  def index
    @list_nav = ListNav.new(params, list_nav,
      { :default_sort_field => 'name',
        :default_sort_direction => 'ASC',
        :limit => PER_PAGE })
    @list_nav.count = Client.count(:conditions => @list_nav.conditions)
    @clients = Client.all(
      :conditions => @list_nav.conditions,
      :order      => @list_nav.order,
      :limit      => @list_nav.limit,
      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash
  end

  def show
    @client = Client.find(params[:id])
    current_user.add_breadcrumb(@client.name, (admin_controller? ? admin_client_path(@client) : client_path(@client)))
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])
    if @client.save
      donemark 'Client was successfully created.'
      audit "Created new client: #{@client.name}"
      redirect_to(admin_controller? ? admin_client_path(@client) : client_path(@client))
    else
      render :action => "new"
    end
  end

  def update
    @client = Client.find(params[:id])

    if @client.update_attributes(params[:client])
      donemark 'Client was successfully updated.'
      audit "Updated client: #{@client.name}"
      redirect_to(admin_controller? ? admin_client_path(@client) : client_path(@client))
    else
      render :action => "edit" 
    end

  end
  
end
