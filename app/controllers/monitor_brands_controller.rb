class MonitorBrandsController < ApplicationController
  def index
  end

  def new
    @monitor_brand = MonitorBrand.new
  end

  def create
    @monitor_brand = MonitorBrand.create(params[:monitor_brand])
    donemark 'New monitor brand successfully created'
    redirect_to new_service_path
  end

end