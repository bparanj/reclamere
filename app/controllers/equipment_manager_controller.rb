class EquipmentManagerController < ApplicationController
  before_filter :solution_owner_admin_required
    
  def index
    @monitor_sizes = MonitorSize.all
    @monitor_brands = MonitorBrand.all
    @cpu_types = CpuType.all
    @cpu_brands = CpuBrand.all
    @cpu_classes = CpuClass.all
    @loose_hard_drive_brands = LooseHardDriveBrand.all
    @flash_hard_drive_brands = FlashHardDriveBrand.all
    @tv_brands = TvBrand.all
    @tv_sizes = TvSize.all
    @magnetic_media_types = MagneticMediaType.all
    @peripheral_brands = PeripheralsBrand.all
    @misc_equipment_types = MiscellaneousEquipmentType.all
    @misc_equipment_brands = MiscellaneousEquipmentBrand.all
  end

  def destroy_monitor_size
    @monitor_size = MonitorSize.find(params[:id])
    @monitor_size.destroy
    audit "Monitor size deleted"
    donemark 'Monitor size deleted successfully'
        
    redirect_to manage_equipment_index_path
  end

  def delete_monitor_brand
    @monitor_brand = MonitorBrand.find(params[:id])
    @monitor_brand.destroy
    audit "Monitor brand deleted"
    donemark 'Monitor brand deleted successfully'
    
    redirect_to manage_equipment_index_path
  end
  
  def delete_cpu_type
    @cpu_type = CpuType.find(params[:id])
    @cpu_type.destroy
    audit "Cpu type deleted"
    donemark 'Cpu type deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_cpu_brand
    @cpu_brand = CpuBrand.find(params[:id])
    @cpu_brand.destroy
    audit "Cpu brand deleted"
    donemark 'Cpu brand deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_cpu_class
    @cpu_class = CpuClass.find(params[:id])
    @cpu_class.destroy
    audit "Cpu class deleted"
    donemark 'Cpu class deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_loose_hard_drive_brand
    lhd = LooseHardDriveBrand.find(params[:id])
    lhd.destroy
    audit "Loose hard drive brand deleted"
    donemark 'Loose hard drive brand deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_flash_hard_drive_brand
    fhdb = FlashHardDriveBrand.find(params[:id])
    fhdb.destroy
    audit "Flash Hard Drive Brand deleted"
    donemark 'Flash Hard Drive Brand deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_tv_brand
    tv_brand = TvBrand.find(params[:id])
    tv_brand.destroy
    audit "Tv brand deleted"
    donemark 'Tv brand deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_tv_size
    tv_size = TvSize.find(params[:id])
    tv_size.destroy
    audit "Tv size deleted"
    donemark 'Tv size deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_magnetic_media_type
    mmt = MagneticMediaType.find(params[:id])
    mmt.destroy
    audit "Magnetic media type deleted"
    donemark 'Magnetic media type deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_peripheral_brand
    pb = PeripheralBrand.find(params[:id])
    pb.destroy
    audit "Printers / Fax / Scanners brand deleted"
    donemark 'Printers / Fax / Scanners brand deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_misc_equipment_type
    met = MiscellaneousEquipmentType.find(params[:id])
    met.destroy
    audit "Miscellaneous Equipment Type deleted"
    donemark 'Miscellaneous Equipment Type deleted successfully'
        
    redirect_to manage_equipment_index_path
    
  end
  
  def delete_misc_equipment_brand
    meb = MiscellaneousEquipmentBrand.find(params[:id])
    meb.destroy
    audit "Miscellaneous Equipment Brand deleted"
    donemark 'Miscellaneous Equipment Brand deleted successfully'
        
    redirect_to manage_equipment_index_path
  end
  
end