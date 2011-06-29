class ServicesController < ApplicationController
  NOT_SELECTED = "Please select"
  
  def index
    @monitors = ComputerMonitor.all
    @cpus = Cpu.all
    @lhds = LooseHardDrive.all
    @fhds = FlashHardDrive.all
    @tvs = Tv.all
    @mms = MagneticMedia.all
    @peripherals = Peripheral.all
    @miscs = MiscellaneousEquipment.all
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
  end

  def create
    make_monitor(params)
    make_cpu(params)
    make_loose_hard_drive(params)
    make_flash_hard_drive(params)
    make_tv(params)
    make_magnetic_media(params)
    make_peripheral(params)
    make_miscellaneous_equipment(params)      
     
    audit "Created new Services at #{Time.now}"
    
    redirect_to services_path    
  end  

  private
  
  def make_monitor(p)
    unless data_was_not_entered_for_monitor
      ComputerMonitor.create(:cm_type => p[:monitor_type], :size => p[:monitor_size], :brand => p[:monitor_brand], :serial => p[:monitor_serial])      
    end
  end

  def make_cpu(p)
    unless data_was_not_entered_for_cpu
      cpu = Cpu.create(:cpu_type => p[:cpu_type], :brand => p[:cpu_brand], :serial => p[:cpu_serial], :cpu_class => p[:cpu_class])
      CpuHardDriveSerial.create(:name => p[:cpu_hard_drive_serial], :cpu_id => cpu.id)      
    end
  end

  def make_loose_hard_drive(p)
    unless data_was_not_entered_for_loose_hard_drive
      LooseHardDrive.create(:brand => p[:loose_hard_drive_brand], :serial => p[:loose_hard_drive_serial])
    end
  end

  def make_flash_hard_drive(p)
    unless data_was_not_entered_for_flash_hard_drive
      FlashHardDrive.create(:brand => p[:flash_hard_drive_brand], :serial => p[:flash_hard_drive_serial])      
    end
  end

  def make_tv(p)
    unless data_was_not_entered_for_tv
      Tv.create(:brand => p[:tv_brand], :size => p[:tv_size], :serial => p[:tv_serial])
    end
  end

  def make_magnetic_media(p)
    unless data_was_not_entered_for_magnetic_media
      MagneticMedia.create(:mm_type => p[:magnetic_media_type], :weight => p[:magnetic_media_weight])
    end
  end

  def make_peripheral(p)
    unless data_was_not_entered_for_peripherals
      peripheral = Peripheral.create(:ptype => p[:peripheral_type], :brand => p[:peripheral_brand], :serial => p[:peripheral_serial])
      peripheral.peripherals_hard_drive_serials.create(:name => p[:peripheral_hard_drive_serial])
    end
  end

  def make_miscellaneous_equipment(p)
    unless data_was_not_entered_for_misc_equipment
      MiscellaneousEquipment.create(:serial => p[:misc_serial], :me_type => p[:misc_type], :brand => p[:misc_brand])
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
end