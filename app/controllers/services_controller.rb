class ServicesController < ApplicationController
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
  
  def make_flash_hard_drive_brand(p)
    FlashHardDriveBrand.create(:name => p[:name])
  end

  def make_tv_size(p)
    TvSize.create(:name => p[:name] )
  end

  def make_tv_brand(p)
    TvBrand.create(:name => p[:name])
  end

  def make_loose_hard_drive_brand(p)
    LooseHardDriveBrand.create(:name => p[:name] )
  end

  def make_cpu_type(p)
    CpuType.create(:name => p[:name] )
  end

  def make_cpu_brand(p)
    CpuBrand.create(:name => p[:cpu_brand])
  end

  def make_cpu_class(p)
    CpuClass.create(:name => p[:cpu_class])
  end

  def make_monitor_brand(p)
    MonitorBrand.create(:name => p[:name] )
  end

  def make_monitor_size(p)
    MonitorSize.create(:name => p[:size] )
  end

  def make_miscellaneous_equipment_brand(p)
    MiscellaneousEquipmentBrand.create(:name => p[:name] )
  end

  def make_miscellaneous_equipment_type(p)
    MiscellaneousEquipmentType.create(:name => p[:name] )
  end

  def make_peripherals_brand(p)
    PeripheralsBrand.create(:name => p[:name] )
  end
  

  private
  
  def make_monitor(p)
    ComputerMonitor.create(:cm_type => p[:monitor_type], :size => p[:monitor_size], :brand => p[:monitor_brand], :serial => p[:monitor_serial])
  end

  def make_cpu(p)
    cpu = Cpu.create(:cpu_type => p[:cpu_type], :brand => p[:cpu_brand], :serial => p[:cpu_serial], :cpu_class => p[:cpu_class])
    CpuHardDriveSerial.create(:name => p[:cpu_hard_drive_serial], :cpu_id => cpu.id)
  end

  def make_loose_hard_drive(p)
    FlashHardDrive.create(:brand => p[:loose_hard_drive_brand], :serial => p[:loose_hard_drive_serial])
  end

  def make_flash_hard_drive(p)
    FlashHardDrive.create(:brand => p[:flash_hard_drive_brand], :serial => p[:flash_hard_drive_serial])
  end

  def make_tv(p)
    Tv.create(:brand => p[:tv_brand], :size => p[:tv_size], :serial => p[:tv_serial])
  end

  def make_magnetic_media(p)
    MagneticMedia.create(:mm_type => p[:magnetic_media_type], :weight => p[:magnetic_media_weight])
  end

  def make_peripheral(p)
    peripheral = Peripheral.create(:ptype => p[:peripheral_type], :brand => p[:peripheral_brand], :serial => p[:peripheral_serial])
    peripheral.peripherals_hard_drive_serials.create(:name => p[:peripheral_hard_drive_serial])
  end

  def make_miscellaneous_equipment(p)
    MiscellaneousEquipment.create(:serial => p[:misc_serial], :me_type => p[:misc_type], :brand => p[:misc_brand])
  end

end