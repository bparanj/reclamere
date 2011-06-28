class MiscellaneousEquipmentBrandsController < ApplicationController
  def new
    @miscellaneous_equipment_brand = MiscellaneousEquipmentBrand.new
  end

  def create
    MiscellaneousEquipmentBrand.create(params[:miscellaneous_equipment_brand])
    donemark 'New Miscellaneous Brand successfully created'
    audit "Created new Miscellaneous Equipment Brand: #{params[:miscellaneous_equipment_brand][:name]}"
    redirect_to new_service_path    
  end

end