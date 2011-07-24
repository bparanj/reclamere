class MonitorSizesController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @monitor_size = MonitorSize.new
  end

  def create
    @monitor_size = MonitorSize.create(params[:monitor_size])
    donemark 'New monitor size successfully created'
    audit "#{current_user.name} created new Monitor size: #{params[:monitor_size][:name]} at #{monitor_size.created_at}"
    
    redirect_to new_service_path
  end

end
