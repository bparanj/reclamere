class ClientsController < ApplicationController
  before_filter :solution_owner_user_required
  before_filter :solution_owner_admin_required, :only => [ :new, :edit, :create, :update ]
  helper :google_maps

  # GET /clients
  # GET /clients.xml
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

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.xml
  def show
    @client = Client.find(params[:id])
    current_user.add_breadcrumb(@client.name, (admin_controller? ? admin_client_path(@client) : client_path(@client)))
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.xml
  def new
    @client = Client.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.xml
  def create
    @client = Client.new(params[:client])
    respond_to do |format|
      if @client.save
        donemark 'Client was successfully created.'
        audit "Created new client: #{@client.name}"
        format.html do
          redirect_to(admin_controller? ? admin_client_path(@client) : client_path(@client))
        end
        format.xml  { render :xml => @client, :status => :created, :location => @client }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.xml
  def update
    @client = Client.find(params[:id])
    respond_to do |format|
      if @client.update_attributes(params[:client])
        donemark 'Client was successfully updated.'
        audit "Updated client: #{@client.name}"
        format.html do
          redirect_to(admin_controller? ? admin_client_path(@client) : client_path(@client))
        end
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
