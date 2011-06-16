class PickupEquipment::DwsCart < Equipment
  ATTRS = [:tracking, :serial, :customer, :country, :model, :comments, :grade, :disposition, :location, :asset_tag]
end
