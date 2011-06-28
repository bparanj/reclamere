class MiscellaneousEquipmentTypesController < ApplicationController
  def new
    @miscellaneous_equipment_type = MiscellaneousEquipmentType.new
  end

  def create
    MiscellaneousEquipmentType.create(params[:miscellaneous_equipment_type])
    donemark 'New Miscellaneous Type successfully created'
    audit "Created new Miscellaneous Equipment Type: #{params[:miscellaneous_equipment_type][:name]}"
    redirect_to new_service_path    
  end

end
