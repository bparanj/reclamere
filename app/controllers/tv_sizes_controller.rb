class TvSizesController < ApplicationController

  def new
    @tv_size = TvSize.new
  end

  def create
    TvSize.create(params[:tv_size])
    donemark 'New Tv size successfully created'
    audit "Created new TV Size: #{params[:tv_size][:name]}"
    
    redirect_to new_service_path    
  end
end
