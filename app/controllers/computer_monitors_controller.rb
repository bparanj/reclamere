class ComputerMonitorsController < ApplicationController
  def edit
    prompt = ["Please select"]
    @monitor = ComputerMonitor.find(params[:id])  
    @monitor_brands = prompt + MonitorBrand.all.collect(&:name)
    @monitor_sizes = prompt + MonitorSize.all.collect(&:name)
  end
  
  def update
    @monitor = ComputerMonitor.find(params[:id])
    
    if @monitor.update_attributes(params[:computer_monitor])
      donemark "Monitor updated successfully"
      redirect_to pickup_equipment_path(@monitor.pickup_id)
    else
      render :action => "update"
    end
  end

end