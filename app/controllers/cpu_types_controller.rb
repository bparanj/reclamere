class CpuTypesController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @cpu_type = CpuType.new
  end

  def create
    CpuType.create(params[:cpu_type])
    donemark 'New cpu type successfully created'
    audit "#{current_user.name} created new CPU Type: #{params[:cpu_type][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end