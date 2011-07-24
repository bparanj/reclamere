class TvSizesController < ApplicationController
  before_filter :solution_owner_user_required

  def new
    @tv_size = TvSize.new
  end

  def create
    TvSize.create(params[:tv_size])
    donemark 'New Tv size successfully created'
    audit "#{current_user.name} created new TV Size: #{params[:tv_size][:name]} at #{Time.now}"
    
    redirect_to new_service_path    
  end
end
