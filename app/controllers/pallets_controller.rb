class PalletsController < ApplicationController
  before_filter :get_pickup
  before_filter :solution_owner_user_required
  
  def index
    get_pallets
  end

  def new
    get_pallets
    @pallet = Pallet.new
  end

  def create
    @pallet = @pickup.pallets.create(params[:pallet])
    
    donemark 'Pallet was successfully created.'
    audit "#{current_user.name} created new Pallet: #{params[:pallet][:number]} at #{Time.now}"
      
    redirect_to new_pickup_pallet_path(@pickup)
  end

  private

  def get_pickup
    @pickup = Pickup.find(params[:pickup_id])
  end
  
  def get_pallets
    @pallets = @pickup.pallets.all(:order => 'number ASC')
  end
end