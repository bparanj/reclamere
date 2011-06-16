class PickupEquipment::Printer < Equipment
  ATTRS = [:tracking, :serial, :customer, :country, :mfg, :model, :comments, :grade, :recycling, :value, :page_count, :disposition, :location, :asset_tag]
end