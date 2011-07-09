class SearchController < ApplicationController
  def new
  end
  
  def index
    @pickups = Pickup.find(:all, 
      :conditions => ['lot_number = ? or  client_reference = ?', params[:lot_number], params[:client_reference]]) 
  end

end
