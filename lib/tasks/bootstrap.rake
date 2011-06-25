desc "Populate drop down values for equipment"

task :populate_drop_downs => :environment do
 MonitorSize.delete_all
 monitor_size_list = ["15\"",  "17\"",  "19\"",  "21\"", "23\""]
 monitor_size_list.each do |x|
  MonitorSize.create(:name => x)
 end
 
 monitor_brand_list =  %w[3M ACER AOC COMPAQ DELL ELO GATEWAY GENERIC HP IBM KDS LENOVO MICROTOUCH MPC NCS NEC PLANAR SAMSUNG TATUNG VIEWSONIC]
 MonitorBrand.delete_all
 monitor_brand_list.each do |x|
   MonitorBrand.create(:name => x )
 end
 
 CpuType.delete_all
 cpu_type_list = ["PC", "Server", "Laptop", "Blackberry", "Cell Phone", "Tablet", "Palm Pilot", "Pocket PC"]
 cpu_type_list.each do |x|
  CpuType.create(:name => x)
 end
 
 CpuBrand.delete_all
 pc_brand_list = ["ACER", "ALTEC LANSING", "ANTEC", "AOPEN", "ASUS","BLACKBERRY","COMPAQ","DELL", "EMACHINES","GATEWAY","GENERIC","HP","IBM","IGEL","LAM","LENOVO","MICROPC","MPC","NCS","SONY","SUN","TREND MICRO"]
 pc_brand_list.each do |x|
  CpuBrand.create(:name => x )
 end
 
 CpuClass.delete_all
 cpu_class_list = %w[CAN P4 PD XEON G5 PM MAC G4 CD C2D]
 cpu_class_list.each do |x|
  CpuClass.create(:name => x )
 end
 
 LooseHardDriveBrand.delete_all
 hdd_list = %w[CAVIER COMPAQ DELL FUJITSU GENERIC HITACHI HP IBM MAXTOR QUANTUM SAMSUNG SEAGATE TOSHIBA WD]
 hdd_list.each do |x|
  LooseHardDriveBrand.create(:name => x )
 end
 
 TvBrand.delete_all
 tv_brand_list = %w[GENERIC PANASONIC PHILIPS POLAROID POLYCOM TOSHIBA VIZIO] 
 tv_brand_list.each do |x|
   TvBrand.create(:name => x )
 end
 
 TvSize.delete_all
 tv_size_list = ["13\"", "25\"", "27\"", "32\""]
 tv_size_list.each do |x|
  TvSize.create(:name => x )
 end
 
 PeripheralsBrand.delete_all
 peripheral_brand_list = %w[BROTHER CANON DELL EMERSON GENERIC HP PANASONIC XEROX ZEBRA]
 peripheral_brand_list.each do |x|
  PeripheralsBrand.create(:name => x )
 end
 
 MiscellaneousEquipmentType.delete_all
 miscellaneous_equipment_type_list = %w[UPS BATTERY MISC TV]
 miscellaneous_equipment_type_list.each do |x|
  MiscellaneousEquipmentType.create(:name => x )
 end
 
 MiscellaneousEquipmentBrand.delete_all
 misc_equip_brand_list = ["3COM", "APC", "BAY NETWORKS", "BELKIN", "CABLETRON", "CISCO", "COMPAQ", "DELL" ,"EMERSON" ,"GE", "GENERIC", "KENMORE", "LINKSYS", "LITEON", "NETGEAR", "NETSCREEN", "NORTEL", "PHILIPS", "POWERHOUSE", "POWERWARE", "SYMBOL (BARCODE SCANNER)", "TRENDNET", "TRIPPLITE"]
 misc_equip_brand_list.each do |x|
  MiscellaneousEquipmentBrand.create(:name => x )
 end
end