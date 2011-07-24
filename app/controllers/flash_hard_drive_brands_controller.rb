class FlashHardDriveBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @flash_hard_drive_brand = FlashHardDriveBrand.new
  end

  def create
    FlashHardDriveBrand.create(params[:flash_hard_drive_brand])
    donemark 'New Flash Hard Drive brand successfully created'
    audit "#{current_user.name} created new Flash Hard Drive Brand : #{params[:flash_hard_drive_brand][:name]} at #{Time.now}"    
    
    redirect_to new_service_path    
  end

end
