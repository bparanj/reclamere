class FlashHardDriveBrandsController < ApplicationController
  def index
  end

  def new
    @flash_hard_drive_brand = FlashHardDriveBrand.new
  end

  def create
    FlashHardDriveBrand.create(params[:flash_hard_drive_brand])
    donemark 'New Flash Hard Drive brand successfully created'
    audit "Created new Flash Hard Drive Brand : #{params[:flash_hard_drive_brand][:name]}"    
    redirect_to new_service_path    
  end

end
