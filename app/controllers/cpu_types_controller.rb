class CpuTypesController < ApplicationController
  def index
  end

  def new
    @cpu_type = CpuType.new
  end

  def create
    CpuType.create(params[:cpu_type])
    donemark 'New cpu type successfully created'
    redirect_to new_service_path    
  end

end