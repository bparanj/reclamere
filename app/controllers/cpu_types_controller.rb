class CpuTypesController < ApplicationController
  def index
  end

  def new
    @cpu_type = CpuType.new
  end

  def create
    CpuType.create(params[:cpu_type])
    donemark 'New cpu type successfully created'
    audit "Created new CPU Type: #{params[:cpu_type][:name]}"
    redirect_to new_service_path    
  end

end