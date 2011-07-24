class LooseHardDriveBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @loose_hard_drive_brand = LooseHardDriveBrand.new
  end

  def create
    LooseHardDriveBrand.create(params[:loose_hard_drive_brand])
    donemark 'New Loose Hard Drive Brand successfully created'
    audit "#{current_user.name} created new Loose Hard Drive Brand: #{params[:loose_hard_drive_brand][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end