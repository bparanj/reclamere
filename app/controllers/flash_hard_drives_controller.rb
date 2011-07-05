class FlashHardDrivesController < ApplicationController
  def edit
    @flash_hard_drive_brands = FlashHardDriveBrand.all.collect(&:name)
    @flash_hard_drive = FlashHardDrive.find(params[:id])
  end

  def update
    @flash_hard_drive = FlashHardDrive.find(params[:id])
    
    if @flash_hard_drive.update_attributes(params[:flash_hard_drive])
      donemark "Flash Hard Drive updated successfully"
      redirect_to pickup_equipment_path(@flash_hard_drive.pickup_id)
    else
      render :action => "update"
    end
  end

end
