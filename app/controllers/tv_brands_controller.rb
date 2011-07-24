class TvBrandsController < ApplicationController
  before_filter :solution_owner_user_required
  
  def index
  end

  def new
    @tv_brand = TvBrand.new
  end

  def create
    TvBrand.create(params[:tv_brand])
    donemark 'New Tv brand successfully created'
    audit "#{current_user.name} created new TV Brand: #{params[:tv_brand][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end

end
