class MiscellaneousEquipmentBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def new
    @miscellaneous_equipment_brand = MiscellaneousEquipmentBrand.new
  end

  def create
    MiscellaneousEquipmentBrand.create(params[:miscellaneous_equipment_brand])
    donemark 'New Miscellaneous Brand successfully created'
    audit "#{current_user.name} created new Miscellaneous Equipment Brand: #{params[:miscellaneous_equipment_brand][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end