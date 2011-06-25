class ServicesController < ApplicationController
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
  end

  def create
    logger.info("Services create...")
  end

  
end

# {"misc_brand"=>"NETSCREEN", "cpu_class"=>"PD", "tv_brand"=>"PHILIPS", "commit"=>"Save",
#    "cpu_serial"=>"1234", "misc_type"=>"UPS", "magnetic_media_weight"=>"454545", 
#    "peripheral_serial"=>"545454", 
#     "monitor_brand"=>"ACER", "flash_hard_drive_brand"=>"Please select", 
#     "peripherals_type"=>"Printer", "cpu_hard_drive_serial"=>"12345", 
#     "peripheral_brand"=>"CANON", "monitor_serial"=>"12345", "flash_hard_drive_serial"=>"242424", 
#     "controller"=>"services", "cpu_type"=>"CPU 1", "monitor_type"=>"CRT", "cpu_brand"=>"AOPEN",
#      "loose_hard_drive_brand"=>"CAVIER", "magnetic_media_type"=>"Floppy",
#       "misc_serial"=>"898989", "monitor_size"=>"17\"", "loose_hard_drive_serial"=>"123456"
#       , "tv_size"=>"27\"", "peripheral_hard_drive_serial"=>"767676"}
# 
