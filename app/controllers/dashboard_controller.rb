class DashboardController < ApplicationController
  before_filter :client_user_required, :only => [ :pickup_request ]

  def index
    if client_user?
      pickup_includes = [:pickup_location]
    else
      pickup_includes = [:pickup_location, :client]
      @recent_feedback = Feedback.recent
    end

    # Requested Pickups
    if client_user?
      rpc = ['status = ? AND client_id = ?', 'Requested', @client.id]
    else
      rpc = ['status = ?', 'Requested']
    end
    @requested_pickups = Pickup.all(:include => pickup_includes,:conditions => rpc, :order => 'pickup_date ASC')

    # Upcoming pickups
    if client_user?
      upc = ['(status = ? OR status = ?) AND client_id = ?', 'Acknowledged', 'Notified', @client.id]
    else
      upc = ['status = ? OR status = ?', 'Acknowledged', 'Notified']
    end
    @upcoming_pickups = Pickup.all(:include => pickup_includes, :conditions => upc, :order => 'pickup_date ASC')

    # In-process pickups
    statuses = ['Picked Up', 'Arrived', 'Sanitized', 'Audited', 'Invoiced']
    if client_user?
      ipc = ['client_id = ? AND status IN (?)', @client.id, statuses]
    else
      ipc = ['status IN (?)', statuses]
    end
    @in_process_pickups = Pickup.all(:include => pickup_includes, :conditions => ipc, :order => 'pickup_date ASC')
  end

  def profile
    @user = current_user
    if request.post?
      if @user.update_attributes(params[:user])
        current_user.reload
        donemark "You've successfully updated your profile."
      end
    end
  end

  def calendar
    if params[:year] && params[:month]
      @date = Date.civil(params[:year].to_i, params[:month].to_i)
    else
      @date = Date.today
    end
    @prev = @date.last_month
    @next = @date.next_month
    conditions = [
      "((YEAR(pickup_date) = ? AND MONTH(pickup_date) = ?) OR " \
        "(YEAR(pickup_date) = ? AND MONTH(pickup_date) = ?) OR " \
        "(YEAR(pickup_date) = ? AND MONTH(pickup_date) = ?))", 
      @date.year, @date.month,
      @prev.year, @prev.month,
      @next.year, @next.month
    ]
    if client_user?
      conditions[0] << ' AND client_id = ?'
      conditions    << @client.id
    end
    # @pickups = Pickup.all(:conditions => conditions, :order => 'pickup_date ASC')
    @pickups = Pickup.all
  end

  def pickup_request
    if request.get?
      @pickup = Pickup.new
    else
      equipment_list = params[:pickup].delete(:equipment_list)
      @pickup = Pickup.new(params[:pickup].merge({ :created_by => current_user }))
      @pickup.status = 'Requested'
      if @pickup.pickup_location
        @pickup.client_user = @pickup.pickup_location.client_user
        @pickup.solution_owner_user = @pickup.pickup_location.solution_owner_user
      end
      Pickup.transaction do
        if @pickup.save
          audit "Submitted pickup request", :auditable => @pickup
          unless equipment_list.blank?
            d = @pickup.root_folder.documents.new({
                :name => 'Equipment List',
                :created_by => current_user,
                :uploaded_data => equipment_list
              })
            unless d.save
              @pickup.errors.add_to_base("Equipment list is an invalid file.")
              raise ActiveRecord::Rollback
            end
            audit "Uploaded equipment list for pickup request", :auditable => @pickup
          end
          @pickup.send_system_email
          donemark "Pickup request submitted successfully."
          redirect_to :action => 'index'
        end
      end
    end
  end

  def do_not_go_here
    raise StandardError, "" \
      "   ############################################\n" \
      "   #------------------------------------------#\n" \
      "   #------ DESTRUCTIVE ACTION CONFIRMED ------#\n" \
      "   #------------------------------------------#\n" \
      "   #-                                        -#\n" \
      "   #- System purge initiated with command:   -#\n" \
      "   #- $ delete --force C:\\*.*                -#\n" \
      "   #-                                        -#\n" \
      "   #------------------------------------------#\n" \
      "   ############################################\n",
      caller
  end
end
