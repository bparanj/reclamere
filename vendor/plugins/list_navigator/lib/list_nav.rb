# Copyright (C) 2008 Avalanche, LLC.
# uses Pickup class to sanitize sql!

module ListNavigator
  
  class ListNav
    DEFAULT_LIMIT = 30
    attr_writer :page
    attr_accessor :count, :limit, :sort_field, :sort_direction,
      :filter_field, :filter_type, :filter_criteria
    
    # Options:
    # :default_sort_field
    # :default_sort_direction
    # :aa = an array of additional attributes to be tracked
    # :limit = number of objects to display in list
    # :conditions = standard conditions to use for sql
    def initialize(request_params = {}, session_data = {}, options = {})
      # set defaults
      @limit = options[:limit] || DEFAULT_LIMIT
      if options[:conditions]
        @conditions = Pickup.send(:sanitize_sql, options[:conditions])
      end
      @page = 1
      @sort_field = options[:default_sort_field]
      @sort_direction = options[:default_sort_direction]
      @filter_field = nil
      @filter_type = nil
      @filter_criteria = nil
      @aa = {}
      if options[:aa].is_a?(Array)
        options[:aa].each { |aa| @aa[aa] = nil }
      end

      unless request_params[:commit] == 'Clear'
        # Page
        if !request_params[:page].blank?
          @page = request_params[:page].to_i
        elsif !session_data[:page].blank?
          @page = session_data[:page].to_i
        else
          @page = 1
        end
        
        # Sort
        if !request_params[:sort_field].blank?
          @sort_field = request_params[:sort_field]
          if session_data[:sort_field] == request_params[:sort_field]
            if session_data[:sort_direction] == 'ASC'
              @sort_direction = 'DESC'
            else
              @sort_direction = 'ASC'
            end
          else
            @sort_direction = 'ASC'
          end
        elsif !session_data[:sort_field].blank? && !session_data[:sort_direction].blank?
          @sort_field = session_data[:sort_field]
          @sort_direction = session_data[:sort_direction]
        else
          @sort_field = options[:default_sort_field]
          @sort_direction = options[:default_sort_direction]
        end
        
        # Filter
        if !request_params[:filter_field].blank? &&
            !request_params[:filter_type].blank?
          @filter_field = request_params[:filter_field]
          @filter_type = request_params[:filter_type]
          @filter_criteria = request_params[:filter_criteria]
          @page = 1
        elsif !session_data[:filter_field].blank? &&
            !session_data[:filter_type].blank?
          @filter_field = session_data[:filter_field]
          @filter_type = session_data[:filter_type]
          @filter_criteria = session_data[:filter_criteria]
        else
          @filter_field = nil
          @filter_type = nil
          @filter_criteria = nil
        end
        
        # Setup additional attribute tracking
        if options[:aa].is_a?(Array)
          options[:aa].each do |aa|
            if request_params[:aa].is_a?(Hash) && !request_params[:aa][aa].blank?
              @aa[aa] = request_params[:aa][aa]
            elsif session_data[:aa].is_a?(Hash) && !session_data[:aa][aa].blank?
              @aa[aa] = session_data[:aa][aa]
            end
          end
        end
      end
    end

    def page
      if @count && @count.to_i < offset
        @page = 1
      else
        @page ||= 1
      end
    end
    
    def conditions
      ret = [filter_conditions, @conditions]
      sql = ret.compact.join(' AND ')
      sql.blank? ? nil : sql
    end

    def set_default_conditions(c)
      @conditions = Pickup.send(:sanitize_sql, c)
    end
    
    def offset
      (@page && @limit) ? (@page - 1) * @limit : 0
    end
    
    def order
      (@sort_field && @sort_direction) ? "#{@sort_field} #{@sort_direction}" : nil
    end
    
    def to_hash
      hash = {}
      hash[:page] = @page if @page
      if !@sort_field.blank? && !@sort_direction.blank?
        hash[:sort_field] = @sort_field
        hash[:sort_direction] = @sort_direction
      end
      if !@filter_field.blank? && !@filter_type.blank?
        hash[:filter_field] = @filter_field
        hash[:filter_type] = @filter_type
        hash[:filter_criteria] = @filter_criteria.to_s
      end
      hash[:aa] = @aa if @aa.is_a?(Hash)
      hash
    end
    
    def num_pages
      (@count.to_f / @limit.to_f).ceil
    end
      
    def method_missing(sym, *args)
      if args.length == 1 && sym.to_s.match(/=$/)
        @aa[sym] = args[0]
      elsif args.length == 0 && !sym.to_s.match(/=$/)
        if @aa.has_key?(sym)
          @aa[sym]
        else
          super
        end
      else
        super
      end
    end

    private
    
    def filter_conditions
      unless @filter_field.blank? || @filter_type.blank?
        str = @filter_field + ' '
        case @filter_type
        when 'contains', 'begins', 'ends'
          str += ' LIKE ?'
        when 'not_contains'
          str += ' NOT LIKE ?'
        when 'not_equals'
          str += ' != ?'
        when 'not_blank'
          str += " != ? AND #{@filter_field} IS NOT NULL"
        else
          str += ' = ?'
        end
        case @filter_type
        when 'contains', 'not_contains'
          cri = '%' + @filter_criteria + '%'
        when 'begins'
          cri = @filter_criteria + '%'
        when 'ends'
          cri = '%' + @filter_criteria
        when 'not_blank'
          cri = ''
        else
          cri = @filter_criteria.to_s
        end
        Pickup.send(:sanitize_sql, [str, cri])
      end
    end
    
  end
  
  def list_nav(options = {})
    session[:list_nav] = [] unless session[:list_nav].is_a?(Array)
    name = options[:name] || request.path.to_sym
    session[:list_nav].detect { |ln| ln.is_a?(Hash) && ln[:name] == name } || {}
  end

  def list_nav=(data)
    session[:list_nav] = [] unless session[:list_nav].is_a?(Array)
    data[:name] ||= request.path.to_sym
    session[:list_nav].delete_if { |ln| ln.is_a?(Hash) && ln[:name] == data[:name] }
    session[:list_nav].unshift(data)
    session[:list_nav] = session[:list_nav][0..4] if session[:list_nav].length > 5
    data
  end
  
end