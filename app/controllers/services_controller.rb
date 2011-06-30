class ServicesController < ApplicationController
  NOT_SELECTED = "Please select"
  
  def index
  end

  def new
    prompt = ["Please select"]
    @monitor_sizes = prompt + MonitorSize.all.collect(&:name)
    @monitor_brands = prompt + MonitorBrand.all.collect(&:name)
    @cpu_types = prompt + CpuType.all.collect(&:name)
    @cpu_brands = prompt + CpuBrand.all.collect(&:name)
    @cpu_classes = prompt + CpuClass.all.collect(&:name)
    @hard_drive_brands = prompt + LooseHardDriveBrand.all.collect(&:name)
    @flash_drive_brands = prompt + FlashHardDriveBrand.all.collect(&:name)
    @tv_brands = prompt + TvBrand.all.collect(&:name)
    @tv_sizes = prompt + TvSize.all.collect(&:name)
    @peripheral_brands = prompt + PeripheralsBrand.all.collect(&:name)
    @misc_types = prompt + MiscellaneousEquipmentType.all.collect(&:name)
    @misc_brands = prompt + MiscellaneousEquipmentBrand.all.collect(&:name)
    get_pickup
  end

  def create
    make_monitor
    make_cpu
    make_loose_hard_drive
    make_flash_hard_drive
    make_tv
    make_magnetic_media
    make_peripheral
    make_miscellaneous_equipment
    
    donemark 'Services Data was successfully saved.' 
    audit "Created new Services at #{Time.now}"
    
    get_pickup
    redirect_to new_pickup_service_path(@pickup)    
  end  

  private
  
  def make_monitor
    unless data_was_not_entered_for_monitor
      ComputerMonitor.create(:cm_type => params[:monitor_type], :size => params[:monitor_size], 
                             :brand => params[:monitor_brand], :serial => params[:monitor_serial])      
    end
  end

  def make_cpu(p)
    unless data_was_not_entered_for_cpu
      cpu = Cpu.create(:cpu_type => params[:cpu_type], :brand => params[:cpu_brand], :serial => params[:cpu_serial], :cpu_class => params[:cpu_class])
      CpuHardDriveSerial.create(:name => params[:cpu_hard_drive_serial], :cpu_id => cpu.id)      
    end
  end

  def make_loose_hard_drive(p)
    unless data_was_not_entered_for_loose_hard_drive
      LooseHardDrive.create(:brand => params[:loose_hard_drive_brand], :serial => params[:loose_hard_drive_serial])
    end
  end

  def make_flash_hard_drive(p)
    unless data_was_not_entered_for_flash_hard_drive
      FlashHardDrive.create(:brand => params[:flash_hard_drive_brand], :serial => params[:flash_hard_drive_serial])      
    end
  end

  def make_tv(p)
    unless data_was_not_entered_for_tv
      Tv.create(:brand => params[:tv_brand], :size => params[:tv_size], :serial => params[:tv_serial])
    end
  end

  def make_magnetic_media(p)
    unless data_was_not_entered_for_magnetic_media
      MagneticMedia.create(:mm_type => params[:magnetic_media_type], :weight => params[:magnetic_media_weight])
    end
  end

  def make_peripheral(p)
    unless data_was_not_entered_for_peripherals
      peripheral = Peripheral.create(:ptype => params[:peripheral_type], :brand => params[:peripheral_brand], :serial => params[:peripheral_serial])
      peripheral.peripherals_hard_drive_serials.create(:name => params[:peripheral_hard_drive_serial])
    end
  end

  def make_miscellaneous_equipment(p)
    unless data_was_not_entered_for_misc_equipment
      MiscellaneousEquipment.create(:serial => params[:misc_serial], :me_type => params[:misc_type], :brand => params[:misc_brand])
    end
  end
    
  def data_was_not_entered_for_monitor
     params[:monitor_type] == NOT_SELECTED && params[:monitor_size] == NOT_SELECTED && params[:monitor_brand] == NOT_SELECTED && params[:monitor_serial].blank?
  end
  
  def data_was_not_entered_for_cpu
    params[:cpu_type] == NOT_SELECTED && params[:cpu_brand] == NOT_SELECTED && params[:cpu_class] == NOT_SELECTED && params[:cpu_serial].blank? && params[:cpu_hard_drive_serial].blank?
  end
  
  def data_was_not_entered_for_loose_hard_drive
    params[:loose_hard_drive_brand] == NOT_SELECTED && params[:loose_hard_drive_serial].blank?
  end

  def data_was_not_entered_for_flash_hard_drive
    params[:flash_hard_drive_brand] == NOT_SELECTED && params[:flash_hard_drive_serial].blank?
  end
  
  def data_was_not_entered_for_tv
    params[:tv_brand] == NOT_SELECTED && params[:tv_size] == NOT_SELECTED
  end

  def data_was_not_entered_for_magnetic_media
    params[:magnetic_media_type] == NOT_SELECTED && params[:magnetic_media_weight].blank? 
  end

  def data_was_not_entered_for_peripherals
    params[:peripheral_type] == NOT_SELECTED && params[:peripheral_brand] == NOT_SELECTED && params[:peripheral_serial].blank? && params[:peripheral_hard_drive_serial].blank?
  end

  def data_was_not_entered_for_misc_equipment
    params[:misc_type] == NOT_SELECTED && params[:misc_brand] == NOT_SELECTED && params[:misc_serial].blank?
  end
  
  def get_pickup
    @pickup = Pickup.find(params[:pickup_id])
  end
end