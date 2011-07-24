class MonitorBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @monitor_brand = MonitorBrand.new
  end

  def create
    @monitor_brand = MonitorBrand.create(params[:monitor_brand])
    donemark 'New monitor brand successfully created'
    audit "#{current_user.name} created new Monitor Brand: #{params[:monitor_brand][:name]} at #{@monitor_brand.created_at}"    
  
    redirect_to new_service_path
  end

end