class LooseHardDriveBrandsController < ApplicationController
  def index
  end

  def new
    @loose_hard_drive_brand = LooseHardDriveBrand.new
  end

  def create
    LooseHardDriveBrand.create(params[:loose_hard_drive_brand])
    donemark 'New Loose Hard Drive Brand successfully created'
    audit "Created new Loose Hard Drive Brand: #{params[:loose_hard_drive_brand][:name]}"
    redirect_to new_service_path    
  end

end