module PickupsHelper

  def pickup_location_options(selected = nil)
    opts = content_tag(:option, '', :value => '') + "\n"
    Client.all(:order => 'name ASC').each do |c|
      pickup_locations = c.pickup_locations.all(:order => 'name ASC')
      if pickup_locations.length > 0
        opts << content_tag(:optgroup, :label => h(c.name)) do
          options_for_select(pickup_locations.map { |pl| [h(pl.name), pl.id] }, (selected ? selected.id : nil))
        end
      end
    end
    opts
  end
  
end
