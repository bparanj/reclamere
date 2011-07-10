class SearchController < ApplicationController
  
  def new
  end
  
  def index    
    if client_user?
      cond = ['(lot_number = ? or  client_reference = ?) and client_id = ?', params[:lot_number], params[:client_reference], current_user.client_id]
    else
      cond = ['lot_number = ? or  client_reference = ?', params[:lot_number], params[:client_reference]]
    end
    @pickups = Pickup.find(:all, :conditions => cond) 
  end

end
