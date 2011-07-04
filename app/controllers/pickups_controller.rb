class PickupsController < ApplicationController
  before_filter :solution_owner_user_required, :except => [ :index, :show, :address ]
  helper :google_maps

  def index
    pickup_includes = [:pickup_location]
    if solution_owner_user?
      conditions = '1'
      pickup_includes << :client
    else
      conditions = ['pickups.client_id = ?', @client.id]  if @client
    end

    @list_nav = ListNav.new(params, list_nav,
      { :default_sort_field => 'pickup_date',
        :default_sort_direction => 'DESC',
        :limit => PER_PAGE,
        :conditions => conditions })
    @list_nav.count = Pickup.count(:conditions => @list_nav.conditions, :include => pickup_includes)
    @pickups = Pickup.all(
      :include    => pickup_includes,
      :conditions => @list_nav.conditions,
      :order      => @list_nav.order,
      :limit      => @list_nav.limit,
      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @pickups }
    end
  end

  def show
    get_pickup
    current_user.add_breadcrumb(@pickup.name, pickup_path(@pickup))
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @pickup }
    end
  end

  def address
    get_pickup
  end

  def new
    @pickup = Pickup.new

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @pickup }
    end
  end

  # Ajax method for new action
  def update_users_list
    render :update do |page|
      pickup_location = PickupLocation.find(params[:pickup_location_id])
      client_users = pickup_location.client.client_users.all(:order => 'name ASC')
      solution_owner_users = SolutionOwnerUser.all(:order => 'name ASC')
      page.replace_html 'client-users-list',
        :partial => 'users_list',
        :locals => {
          :users => client_users,
          :selected_user => pickup_location.client_user,
          :attr_method => 'pickup[client_user_id]'
        }
      page.replace_html 'solution-owner-users-list',
        :partial => 'users_list',
        :locals => {
          :users => solution_owner_users,
          :selected_user => pickup_location.solution_owner_user,
          :attr_method => 'pickup[solution_owner_user_id]'
        }
    end
  end

  def edit
    @pickup = Pickup.find(params[:id])
  end

  def acknowledge
    @pickup = Pickup.find(params[:id])
    if @pickup.status == 'Requested'
      if @pickup.acknowledge_pickup
        audit "Acknowledged pickup \"#{@pickup.name}\"", :auditable => @pickup
        donemark "Pickup has been acknowledged."
      else
        errormessage "Unable to acknowledge pickup:", "<ul>" + @pickup.errors.full_messages.map { |m| "<li>#{m}</li>" }.join("\n")
      end
    else
      warningmark "Only a requested pickup needs to be acknowledged."
    end
    redirect_to pickup_path(@pickup)
  end

  def notify
    @pickup = Pickup.find(params[:id])
    if @pickup.status == 'Acknowledged'
      if @pickup.notify_pickup(false)
        audit "Manually notified client of upcoming pickup \"#{@pickup.name}\"", :auditable => @pickup
        donemark "Client has been notified of pickup."
      else
        errormessage "Unable to notify client of pickup:", "<ul>" + @pickup.errors.full_messages.map { |m| "<li>#{m}</li>" }.join("\n")
      end
    else
      warningmark "Only an acknowledged pickup needs to be notified."
    end
    redirect_to pickup_path(@pickup)
  end

  def close_feedback
    @pickup = Pickup.find(params[:id])
    if @pickup.status == 'Feedback'
      @pickup.status = 'Closed'
      if @pickup.save
        donemark "Successfully closed pickup from feedback."
        audit "Closed pickup \"#{@pickup.name}\" from feedback"
      else
        errormark 'Unable to close pickup from feedback.'
      end
    end
    redirect_to pickup_path(@pickup)
  end

  def create
    @pickup = Pickup.new(params[:pickup])
    @pickup.status = 'Picked Up'
    @pickup.created_by = current_user
    @pickup.pickup_type = @pickup.pickup_type.join(",")
    respond_to do |format|
      if @pickup.save
        donemark 'Pickup was successfully created.'
        audit "Created pickup \"#{@pickup.name}\"", :auditable => @pickup
        format.html { redirect_to(@pickup) }
        format.xml  { render :xml => @pickup, :status => :created, :location => @pickup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pickup.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @pickup = Pickup.find(params[:id])

    respond_to do |format|
      if @pickup.update_attributes(params[:pickup])
        @pickup.pickup_type = @pickup.pickup_type.join(",")
        @pickup.save
        donemark 'Pickup was successfully updated.'
        audit "Updated pickup \"#{@pickup.name}\"", :auditable => @pickup
        format.html { redirect_to(@pickup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pickup.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    get_pickup
    if solution_owner_user?
      @pickup.destroy
      name = @pickup.name.blank? ? '[pickup]' : @pickup.name
      donemark "Pickup \"#{name}\" was successfully deleted."
      audit "Deleted pickup \"#{name}\" from \"#{@pickup.client.name}\""
      redirect_to pickups_path
    else
      errormark "You cannot delete this pickup."
      redirect_to @pickup
    end
  end

  def print_work_order
    @pickup = Pickup.find(params[:id])
    respond_to do |format|
      format.pdf { 
        send_data render_to_pdf({ :action => 'print_work_order.rpdf', :layout => 'pdf_report' }), :filename => "work_order.pdf"
       } 
    end
  end
  
  private

  def get_pickup
    if client_user?
      @pickup = Pickup.find(params[:id], :conditions => ['client_id = ?', @client.id])
    else
      @pickup = Pickup.find(params[:id])
    end
  end
end
