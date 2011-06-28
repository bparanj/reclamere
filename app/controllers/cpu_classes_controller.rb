class CpuClassesController < ApplicationController
  def index
  end

  def new
    @cpu_class = CpuClass.new
  end

  def create
    CpuClass.create(params[:cpu_class])
    donemark 'New cpu class successfully created'
    redirect_to new_service_path    
  end

end