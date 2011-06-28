class PeripheralsBrandsController < ApplicationController
  def new
    @peripherals_brand = PeripheralsBrand.new
  end

  def create
    PeripheralsBrand.create(params[:peripherals_brand])
    donemark 'New brand successfully created'
    audit "Created new Printers / Fax / Scanners Brand: #{params[:peripherals_brand][:name]}"
    
    redirect_to new_service_path    
  end
end