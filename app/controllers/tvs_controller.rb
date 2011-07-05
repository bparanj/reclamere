class TvsController < ApplicationController
  def edit
    @tv_brands = TvBrand.all.collect(&:name)
    @tv_sizes = TvSize.all.collect(&:name)
    @tv = Tv.find(params[:id])
  end

  def update
    @tv = Tv.find(params[:id])
    
    if @tv.update_attributes(params[:tv])
      donemark "Tv updated successfully"
      redirect_to pickup_equipment_path(@tv.pickup_id)
    else
      render :action => "update"
    end
  end

end