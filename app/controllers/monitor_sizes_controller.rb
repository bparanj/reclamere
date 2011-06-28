class MonitorSizesController < ApplicationController
  def index
  end

  def new
    @monitor_size = MonitorSize.new
  end

  def create
    @monitor_size = MonitorSize.create(params[:monitor_size])
    donemark 'New monitor size successfully created'
    audit "Created new Monitor size: #{params[:monitor_size][:name]}"
    
    redirect_to new_service_path
  end

end
