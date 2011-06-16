module EquipmentHelper

  def equipment_path(container, equipment)
    case container
    when Pickup
      pickup_equip_path(container, equipment)
    when Client
      client_equip_path(container, equipment)
    end
  end

  def equipment_list_path(container)
    case container
    when Pickup
      pickup_equipment_path(container)
    when Client
      client_equipment_path(container)
    end
  end

  def import_map_select(column, columns, header = [])
    if header[column]
      selected = header[column].to_s.gsub(/[\s]+/, '_').underscore
    else
      selected = nil
    end
    select_tag "import_map[#{column}]",
      options_for_select(([nil] + columns).map { |c| [c.to_s.titlecase, c.to_s] }, selected)
  end

  def type_dom_id(type)
    type.downcase.gsub(/[\s]+/, '_') + '_header_list'
  end
end
