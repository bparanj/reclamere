class PeripheralsBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def new
    @peripherals_brand = PeripheralsBrand.new
  end

  def create
    PeripheralsBrand.create(params[:peripherals_brand])
    donemark 'New brand successfully created'
    audit "#{current_user.name} created new Printers / Fax / Scanners Brand: #{params[:peripherals_brand][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end
end