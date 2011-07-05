class PeripheralsController < ApplicationController
  def edit
    @peripheral_brands = PeripheralsBrand.all.collect(&:name)
    @peripheral_types = Peripheral::DROP_DOWN_LIST
    @peripheral = Peripheral.find(params[:id])
  end

  def update
    @peripheral = Peripheral.find(params[:id])
    
    if @peripheral.update_attributes(params[:peripheral])
      donemark "Tv updated successfully"
      redirect_to pickup_equipment_path(@peripheral.pickup_id)
    else
      render :action => "update"
    end
  end

end