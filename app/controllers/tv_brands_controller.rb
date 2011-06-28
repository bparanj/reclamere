class TvBrandsController < ApplicationController
  def index
  end

  def new
    @tv_brand = TvBrand.new
  end

  def create
    TvBrand.create(params[:tv_brand])
    donemark 'New Tv brand successfully created'
    audit "Created new TV Brand: #{params[:tv_brand][:name]}"
    
    redirect_to new_service_path    
  end

end
