class InternalDocumentsController < ApplicationController
  def new
    @pickup = Pickup.find(params[:pickup_id])
  end
  
  def create
    logger.info "Uploaded file name is : #{params[:upload][:filename]}"
    pickup = Pickup.find(params[:pickup_id])
    post = InternalDocument.save(params[:upload], current_user.id, pickup.id)
    donemark "File uploaded successfully"
    audit "#{current_user.login} uploaded new internal document : #{params[:upload][:filename]}"
    
    redirect_to new_pickup_internal_document_path(pickup) 
  end

end
