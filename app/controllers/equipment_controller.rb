class EquipmentController < ApplicationController
  before_filter :get_container
  before_filter :solution_owner_user_required, :only => [ :upload, :import, :destroy ]

  def index
    @monitors = @container.computer_monitors.all
    @cpus = @container.cpus.all
    @lhds = @container.loose_hard_drive.all
    @fhds = @container.flash_hard_drive.all
    @tvs = @container.tvs.all
    @mms = @container.magnetic_medias.all
    @peripherals = @container.peripherals.all
    @miscs = @container.miscellaneous_equipments.all     
  end

  def show
    @equipment = @container.equipment.find(params[:id])
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

    redirect_to(polymorphic_path([@container, :equipment]))
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
