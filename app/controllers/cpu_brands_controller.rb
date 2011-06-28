class CpuBrandsController < ApplicationController
  def index
  end

  def new
    @cpu_brand = CpuBrand.new
  end

  def create    
    CpuBrand.create(params[:cpu_brand])
    donemark 'New cpu brand successfully created'
    audit "Created new CPU Brand: #{params[:cpu_brand][:name]}"
    redirect_to new_service_path    
  end

end