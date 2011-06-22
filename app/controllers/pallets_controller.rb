class PalletsController < ApplicationController
  def index
    @pallets = Pallet.all
  end

  def new
    @pallet = Pallet.new
  end

  def create
    @pallet = Pallet.new(params[:pallet])
    
    if @pallet.save
      donemark 'Pallet was successfully created.'
      redirect_to new_pallet_path
    else
      render :action => "new"
    end
  end

end
