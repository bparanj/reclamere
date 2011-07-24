class PickupLocationsController < ApplicationController
  before_filter :solution_owner_admin_required, :only => [ :new, :edit, :create, :update, :update_client_users_list ]
  helper :google_maps

  def index
    if solution_owner_user?
      conditions = '1'
    else
      conditions = ['pickup_locations.client_id = ?', @client.id] if @client
    end
    @list_nav = ListNav.new(params, list_nav, { :default_sort_field => 'pickup_locations.name',
                                                :default_sort_direction => 'ASC',
                                                :limit => PER_PAGE,
                                                :conditions => conditions })
    @list_nav.count = PickupLocation.count(:conditions => @list_nav.conditions,
                                           :include => [:client, :client_user])
    @pickup_locations = PickupLocation.all(:include    => [:client, :client_user],
                                           :conditions => @list_nav.conditions,
                                           :order      => @list_nav.order,
                                           :limit      => @list_nav.limit,
                                           :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash
  end

  def show
    @pickup_location = PickupLocation.find(params[:id])
    if client_user? && @pickup_location.client_id != @client.id
      access_denied
    else
      current_user.add_breadcrumb(@pickup_location.name, (admin_controller? ? admin_pickup_location_path(@pickup_location) : pickup_location_path(@pickup_location)))
    end
  end

  def new
    @pickup_location = PickupLocation.new
  end

  # Ajax method for new action
  def update_client_users_list
    render :update do |page|
      users = Client.find(params[:client_id]).client_users
      page.replace_html 'client_user_select', :partial => 'user_select', :locals => { :users => users }
    end
  end

  def edit
    @pickup_location = PickupLocation.find(params[:id])
  end

  def create
    @pickup_location = PickupLocation.new(params[:pickup_location])

    if @pickup_location.save
      donemark 'Pickup Location was successfully created.'
      audit "Created pickup location #{@pickup_location.name}"
      redirect_to(admin_controller? ? admin_pickup_location_path(@pickup_location) : pickup_location_path(@pickup_location))
    else
      render :action => "new"
    end
  end

  def update
    @pickup_location = PickupLocation.find(params[:id])
    params[:pickup_location].delete(:client_id)

    if @pickup_location.update_attributes(params[:pickup_location])
      donemark 'Pickup Location was successfully updated.'
      audit "Updated pickup location #{@pickup_location.name}"
      redirect_to(admin_controller? ? admin_pickup_location_path(@pickup_location) : pickup_location_path(@pickup_location)) 
    else
      render :action => "edit"
    end

  end

end
