class MiscellaneousEquipmentTypesController < ApplicationController
  before_filter :solution_owner_user_required
  
  def new
    @miscellaneous_equipment_type = MiscellaneousEquipmentType.new
  end

  def create
    MiscellaneousEquipmentType.create(params[:miscellaneous_equipment_type])
    donemark 'New Miscellaneous Type successfully created'
    audit "#{current_user.name} created new Miscellaneous Equipment Type: #{params[:miscellaneous_equipment_type][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end
