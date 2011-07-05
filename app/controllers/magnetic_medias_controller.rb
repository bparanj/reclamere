class MagneticMediasController < ApplicationController
  def edit
    @magnetic_media_types = MagneticMedia::DROP_DOWN_LIST
    @magnetic_media = MagneticMedia.find(params[:id])
  end

  def update
    @magnetic_media = MagneticMedia.find(params[:id])
    
    if @magnetic_media.update_attributes(params[:magnetic_media])
      donemark "Magnetic Media updated successfully"
      redirect_to pickup_equipment_path(@magnetic_media.pickup_id)
    else
      render :action => "update"
    end
  end
  
end