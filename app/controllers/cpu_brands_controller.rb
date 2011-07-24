class CpuBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @cpu_brand = CpuBrand.new
  end

  def create    
    CpuBrand.create(params[:cpu_brand])
    donemark 'New cpu brand successfully created'
    audit "#{current_user.name} created new CPU Brand: #{params[:cpu_brand][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end