module DashboardHelper

  def calendar_pickup_link(pickup)
    content_tag(:div, :class => 'calendar-event') do
      link_to(h(pickup.name), pickup_path(pickup)) +
        (solution_owner_user? ? " (#{link_to(h(pickup.client.name), client_path(pickup.client))})" : '')
    end
  end
end
