module ApplicationHelper
  include Messaging

  def admin_controller?
    @controller.send :admin_controller?
  end

  def error_messages_for(*params)
    options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
    objects = params.collect { |object_name| instance_variable_get("@#{object_name}") }.compact
    count   = objects.inject(0) { |sum, object| sum + object.errors.count }
    unless count.zero?
      header_message = "#{pluralize(count, 'error')} prohibited this #{(options[:object_name] || params.first).to_s.gsub('_', ' ')} from being saved"
      error_messages = objects.map {|object| object.errors.full_messages.map { |msg| content_tag(:li, msg, :style => 'font-weight: bold') } }
      htmlerrormessage(content_tag(:p, header_message),
        content_tag(:p, 'There were problems with the following fields:') + content_tag(:ul, error_messages))
    end
  end

  def link_to_selfref(name, options, html_options = {})
    selected = link_selected?(options, html_options)
    if selected
      if html_options[:class].is_a?(String)
        html_options[:class] << ' selfref'
      else
        html_options[:class] = 'selfref'
      end
    end
    link_to(h(name), options, html_options)
  end

  def link_to_tab(name, options, html_options = {})
    selected = link_selected?(options, html_options)
    content_tag(selected ? :th : :td, link_to(h(name), options, html_options))
  end

  def link_to_pickup(pickup)
    name = pickup.name
    name = '[pickup]' if name.blank?
    link_to(name, pickup_path(pickup))
  end

  def print_tasks(options = {})
    content = yield([]).compact.join(' | ')
    content_tag(options[:tag] || :p, content, { :class => options[:class] || 'tasknav'})
  end
  
  def print_date(date = Date.today)
    if date.respond_to?(:strftime)
      date.strftime(DATE_FORMAT)
    else
      '&nbsp;'
    end
  end

  def print_datetime(time = Time.zone.now)
    if time.respond_to?(:strftime)
      time.strftime(DATETIME_FORMAT)
    else
      '&nbsp;'
    end
  end

  def dist_time_words(time, start_time = nil)
    time = time.to_time if time.is_a?(Date)
    if time.is_a?(Time)
      start_time ||= Time.now
      if (time - start_time).to_f.abs >= 86400.0
        w = distance_of_time_in_words(start_time, time)
        g = start_time < time ? 'from now' : 'ago'
      else
        w = nil
      end
    else
      w = nil
    end
    if w
      content_tag(:span, "#{w} #{g}", :style => "font-size: smaller; font-style: italic; color: gray;")
    else
      ''
    end
  end

  def add_stylesheets(*sheets)
    @stylesheets ||= []
    @stylesheets |= sheets
  end

  def stylesheets
    s = ['tigris', 'style']
    if @stylesheets.is_a?(Array)
      s |= @stylesheets
    end
    stylesheet_link_tag(*s)
  end

  def add_javascripts(*scripts)
    @javascripts ||= []
    @javascripts |= scripts
  end

  def javascripts
    # defaults = application, controls, dragdrop, effects, prototype
    if @javascripts.is_a?(Array) && @javascripts.length > 0
      javascript_include_tag(*@javascripts)
    else
      nil
    end
  end

  def add_to_html_head(str)
    unless str.blank?
      @html_head ||= []
      @html_head |= [str]
    end
  end

  def html_head
    [(@html_head || []).join("\n"), stylesheets, javascripts].join("\n")
  end

  def current_tab
    @current_tab ||= if admin_controller?
      'admin'
    elsif params[:controller] == 'dashboard'
      'dashboard'
    elsif ['pickups', 'tasks', 'system_emails', 'feedbacks'].include?(params[:controller])
      'pickups'
    elsif params[:controller] ==  'clients'
      'clients'
    elsif params[:controller] == 'pickup_locations'
    'pickup_locations'
    elsif @folderable
      if @folderable.is_a?(Pickup)
        'pickups'
      elsif @folderable.is_a?(Client)
        if solution_owner_user?
          'clients'
        else
          'corporate_documents'
        end
      end
    elsif @auditable
      'pickups'
    elsif @container
      if @container.is_a?(Pickup)
        'pickups'
      else
        if solution_owner_user?
          'clients'
        else
          'client_equipment'
        end
      end
    else
      nil
    end
  end

  def current_tab?(tab)
    return false if tab.blank?
    current_tab == tab
  end

  def more_less_text(text, options = {})
    length = options[:length] || 140
    start_with_more = !!options[:start_with_more]
    tag = options[:tag] || :div
    html_class = options[:class] || 'more-less-text'
    @mlt_num ||= 0
    @mlt_num += 1
    id = "mlt_#{@mlt_num}"
    transform = options[:transform] || Proc.new { |str| simple_format(str) }
    text = h(text.to_s.strip)
    if text.blank?
      content_tag(tag, '&nbsp;', :id => id, :class => html_class)
    elsif text.length < length
      content_tag(tag, text, :id => id, :class => html_class)
    else
      add_javascripts 'prototype'
      content_tag(tag, :id => "#{id}_less", :class => html_class, :style => "display: #{start_with_more ? 'none'  : 'block'};") do
        (text[0...length] + '... ') +
          link_to_function('show more', {}, { :style => 'font-size: smaller; color: gray;' }) do |page|
          page[:"#{id}_less"].hide
          page[:"#{id}_more"].show
        end
      end +
        content_tag(tag, :id => "#{id}_more", :class => html_class, :style => "display: #{start_with_more ? 'block' : 'none'};") do
        transform.call(text) + "\n" +
          link_to_function('show less', {}, { :style => 'font-size: smaller; color: gray;' }) do |page|
          page[:"#{id}_more"].hide
          page[:"#{id}_less"].show
        end
      end
    end
  end

  # Used only for testing/debugging
  def display_obj(obj)
    content_tag :pre, simple_format(obj.pretty_inspect).gsub(/\#</, '#&lt;')
  end
  
  # Use this to wrap view elements that the user can't access.
  # !! Note: this is an *interface*, not *security* feature !!
  # You need to do all access control at the controller level.
  #
  # Example:
  # <%= if_authorized?(:index,   User)  do link_to('List all users', users_path) end %> |
  # <%= if_authorized?(:edit,    @user) do link_to('Edit this user', edit_user_path) end %> |
  # <%= if_authorized?(:destroy, @user) do link_to 'Destroy', @user, :confirm => 'Are you sure?', :method => :delete end %>
  #
  #
  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  private

  def link_selected?(options, html_options)
    if html_options.has_key?(:if)
      html_options.delete(:if)
    else
      if options.is_a?(String)
        options == request.path
      elsif options.is_a?(Hash)
        current_page?(options)
      else
        selected = false
      end
    end
  end
end
