class LooseHardDrivesController < ApplicationController
  def edit
    @loose_hard_drive_brands = LooseHardDriveBrand.all.collect(&:name)
    @loose_hard_drive = LooseHardDrive.find(params[:id])
  end

  def update
    @loose_hard_drive = LooseHardDrive.find(params[:id])
    
    if @loose_hard_drive.update_attributes(params[:loose_hard_drive])
      donemark "Loose Hard Drive updated successfully"
      redirect_to pickup_equipment_path(@loose_hard_drive.pickup_id)
    else
      render :action => "update"
    end
  end

end