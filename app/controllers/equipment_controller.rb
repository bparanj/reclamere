class EquipmentController < ApplicationController
  before_filter :get_container
  before_filter :solution_owner_user_required, :only => [ :upload, :import, :destroy ]

  def index
    if @container.is_a?(Client)
      equipment_includes = [:pickup]
    else
      equipment_includes = []
    end
    @list_nav = ListNav.new(params, list_nav,
      { :default_sort_field => 'type_name',
        :default_sort_direction => 'ASC',
        :limit => PER_PAGE })
    @list_nav.count = @container.equipment.count(:conditions => @list_nav.conditions, :include => equipment_includes)
    @equipment = @container.equipment.all(
      :include => equipment_includes,
      :conditions => @list_nav.conditions,
      :order      => @list_nav.order,
      :limit      => @list_nav.limit,
      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @equipment }
    end
  end

  def show
    @equipment = @container.equipment.find(params[:id])

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @equipment }
    end
  end

  def export
    if @container.is_a?(Client)
      @equipment_export = OpenStruct.new(params[:equipment_export] || {})
      if request.post?
        result = Equipment.export_csv(@container, params[:equipment_export].merge({ :client_user => client_user? }))
        if result.is_a?(Array)
          result.each do |e|
            errormark(e)
          end
        elsif result.is_a?(String) && result.strip != ''
          send_data(result,
            :filename => "#{Date.today.strftime('%Y%m%d')}-equipment_export-#{AppUtils.clean_string(@container.name, :delimiter => '_')}.csv",
            :type => 'text/csv')
        else
          infomark('No equipment matches criteria!')
        end
      end
    else
      access_denied
    end
  end

  def upload
    if @container.is_a?(Pickup)
      if request.get?
        @document = Document.new
      else
        @document = EquipmentImport.upload_import_document(params[:equipment_type], params[:document], @container, current_user)
        if !@document.new_record? && @document.valid?
          donemark "Successfully uploaded equipment list."
          audit "Uploaded equipment list for pickup \"#{@container.name}\"", :auditable => @container
          redirect_to import_pickup_equipment_path(@container, @document, params[:equipment_type])
        end
      end
    else
      access_denied "You can only upload an equipment list in the context of a pickup!"
    end
  end

  def import
    if @container.is_a?(Pickup)
      document = @container.equipment_import_folder.documents.find(params[:id])
      @import = EquipmentImport.new(@container, document, params[:equipment_type], current_user)
      if request.post? && params[:commit] == 'Import'
        @import.save(params[:import_map])
        donemark "#{@import.type} Equipment Import Complete!"
        audit "Imported #{@import.type} Equipment for pickup \"#{@container.name}\"", :auditable => @container
      elsif !@import.valid?
        @import.errors.each do |e|
          errormark e
        end
      end
    else
      access_denied "You can only import an equipment list in the context of a pickup!"
    end
  end

  def destroy
    @equipment = @container.equipment.find(params[:id])
    @equipment.destroy
    donemark "Successfully deleted equipment."
    audit "Deleted equipment #{@equipment.type_name.downcase} #{@equipment.serial}", :auditable => @container

    respond_to do |format|
      format.html { redirect_to(polymorphic_path([@container, :equipment])) }
      format.xml  { head :ok }
    end
  end

  private

  def get_container
    if params[:pickup_id]
      @container = Pickup.find(params[:pickup_id])
      if client_user? && @container.client != @client
        access_denied
      end
    elsif params[:client_id]
      @container = Client.find(params[:client_id])
      if client_user? && @container != @client
        access_denied
      end
    end
  end
end
