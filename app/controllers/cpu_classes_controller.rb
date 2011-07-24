class CpuClassesController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @cpu_class = CpuClass.new
  end

  def create
    CpuClass.create(params[:cpu_class])
    donemark 'New cpu class successfully created'
    audit "#{current_user.name} created new CPU Class: #{params[:cpu_class][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end