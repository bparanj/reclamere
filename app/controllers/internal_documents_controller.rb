class InternalDocumentsController < ApplicationController
  before_filter :solution_owner_user_required

  def new
    _find_pickup
    @internal_docs = @pickup.internal_documents
  end
  
  def create
    logger.info "Uploaded file name is : #{params[:upload][:filename]}"
    pickup = _find_pickup
    post = InternalDocument.save(params[:name], params[:upload], current_user.id, pickup.id)
    donemark "File uploaded successfully"
    audit "#{current_user.login} uploaded new internal document : #{params[:upload][:filename]}"
    
    redirect_to new_pickup_internal_document_path(pickup) 
  end

  def download
    _find_pickup
    doc = @pickup.internal_documents.find(params[:id])
    absolute_filename = "#{STORAGE_FOLDER}/#{doc.filename}" 
    file_exists = File.exist?(absolute_filename)
    
    if file_exists
      send_file(absolute_filename, 
               :filename => doc.filename,
               :type => doc.content_type, 
               :disposition => 'attachment', 
               :streaming => true)
      audit "Downloaded document \"#{@doc.filename}\"", :auditable => @pickup
    else
      errormark "Sorry, unable to retrieve this file at this time. Please try again later."
    end
    
  end

  def destroy
    _find_pickup
    @internal_doc = @pickup.internal_documents.find(params[:id])
    @internal_doc.delete_file
    @internal_doc.destroy

    donemark "Document \"#{@internal_doc.filename}\" was deleted successfully."
    audit "Deleted document \"#{@internal_doc.filename}\"", :auditable => @pickup

    redirect_to new_pickup_internal_document_path(@pickup)     
  end
  
  private
  
  def _find_pickup
    @pickup = Pickup.find(params[:pickup_id])    
  end
end
