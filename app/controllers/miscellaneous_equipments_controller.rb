class MiscellaneousEquipmentsController < ApplicationController
  def edit
    @misc_brands = MiscellaneousEquipmentBrand.all.collect(&:name)
    @misc_types = MiscellaneousEquipmentType.all.collect(&:name)
    @misc = MiscellaneousEquipment.find(params[:id])
  end

  def update
    @misc = MiscellaneousEquipment.find(params[:id])
    
    if @misc.update_attributes(params[:miscellaneous_equipment])
      donemark "Tv updated successfully"
      redirect_to pickup_equipment_path(@misc.pickup_id)
    else
      render :action => "update"
    end
  end

end