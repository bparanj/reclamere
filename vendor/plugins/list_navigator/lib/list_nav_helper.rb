# Copyright (C) 2008 Avalanche, LLC.

module ListNavHelper
  DEFAULT_WINDOW_SIZE = 8
  
  # Expects an array [[text, value], ...]
  def list_nav_filter(list)
    s  = '<table class="axial"><tr>'
    s += '<th>Filter</th><td>'
    if list.length == 1
      s += list.first.first
      s += '&nbsp;<input type="hidden" name="filter_field" value="' + list.first.last + '" />'
    else
      s += '<select name="filter_field">'
      s += options_for_select(list, @list_nav.filter_field)
      s += '</select>'
    end
    s += '<select name="filter_type">'
    s += options_for_select([['contains', 'contains'], 
        ['does not contain', 'not_contains'], 
        ['begins with', 'begins'], 
        ['ends with', 'ends'], 
        ['equals', 'equals'],
        ['does not equal', 'not_equals'],
        ['is not blank', 'not_blank']], @list_nav.filter_type)
    s += '</select>'
    s += '<input type="text" name="filter_criteria" value="' + @list_nav.filter_criteria.to_s + '" />'
    s += submit_tag('Filter') + ' ' + submit_tag('Clear')
    s += '</td></tr></table>'
  end

  def list_nav_header(text, value, options = {}, html_options = {})
    s = ''
    if @list_nav.sort_field == value
      if @list_nav.sort_direction == 'ASC'
        s += '<span class="sortup"></span>'
      elsif @list_nav.sort_direction == 'DESC'
        s += '<span class="sortdown"></span>'
      end
    end
    s += link_to(text, ln_path(options, { :sort_field => value }), html_options)
    s
  end

  def list_nav_pagination(options = {}, html_options = {})
    if @list_nav.num_pages > 1
      window_size = DEFAULT_WINDOW_SIZE / 2
      pages = ((1..window_size).to_a + 
          ((@list_nav.page - window_size)..(@list_nav.page + window_size)).to_a + 
          ((@list_nav.num_pages - window_size)..(@list_nav.num_pages)).to_a).delete_if do |p|
        p < 1 || p > @list_nav.num_pages
      end.uniq.sort

      links = []
      last = nil
      if @list_nav.page != 1
        links << link_to('< Previous', ln_path(options, { :page => @list_nav.page - 1 }), html_options)
      else
        links << '< Previous'
      end
      pages.each do |p|
        if last && (p - 1 > last)
          links << '...'
        end
        if p == @list_nav.page
          links << content_tag(:strong, p)
        else
          links << link_to(p, ln_path(options, { :page => p }), html_options)
        end
        last = p
      end
      if @list_nav.page != @list_nav.num_pages
        links << link_to('Next >', ln_path(options, { :page => @list_nav.page + 1 }), html_options)
      else
        links << 'Next >'
      end
      content_tag(:p, links.join(' | ') + ('&nbsp;' * 5) + pagination_position(@list_nav), :class => 'paginate')
    end
  end
  
  protected

  def ln_path(options = {}, attrs = {})
    if p = options.delete(:path)
      case p
      when Symbol
        send(p, attrs)
      when Array
        polymorphic_path(p, attrs)
      when Hash
        p.merge(attrs)
      else
        attrs
      end
    else
      attrs
    end
  end

  def pagination_position(nav)
    start_num = nav.offset + 1
    end_num = (start_num + nav.limit) - 1
    end_num = nav.count if end_num > nav.count
    "#{start_num} through #{end_num} of #{nav.count}"
  end
end