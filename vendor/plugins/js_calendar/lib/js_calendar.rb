module JsCalendar
  module Helper
    
    def js_date_select_tag(name, date = nil, options = {})
      add_stylesheets('js_calendar')
      add_javascripts('js_calendar/calendar', 'js_calendar/calendar-en', 'js_calendar/calendar-setup')
      content = if date.respond_to?(:strftime)
        date.strftime(DATE_FORMAT)
      elsif date.is_a?(String)
        date
      elsif options[:default_today]
        Date.today.strftime(DATE_FORMAT)
      else
        ''
      end
      new_name = name.to_s.gsub((/(\[([\w]+)\])/)) { |r| "_#{$2}" }
      trigger = new_name + "_trigger"
      str = text_field_tag(name, content, options.merge({ :size => '10' })) +
      '&nbsp;' + image_tag('calendar.gif', { :id => trigger }) +
      '&nbsp;<span style="color: gray; font-size: smaller">example: ' + Date.today.strftime(DATE_FORMAT) + '</span>'
      unless options[:diabled]
        str << javascript_tag( 'Calendar.setup({ inputField: "' + new_name + '", singleClick: false, ifFormat: "' + DATE_FORMAT + '", button: "' + trigger + '" });' )
      end
      str
    end
  
    def js_date_select(object, method, options = {})
      add_stylesheets('js_calendar')
      add_javascripts('js_calendar/calendar', 'js_calendar/calendar-en', 'js_calendar/calendar-setup')
      str = text_field(object, method, options.merge({ :size => '10' })) +
        '&nbsp;' + image_tag('calendar.gif', { :id => object + '_' + method + '_trigger' }) +
        '&nbsp;<span style="color: gray; font-size: smaller">example: ' + Date.today.strftime(DATE_FORMAT) + '</span>'
      unless options[:disabled]
        str << javascript_tag( 'Calendar.setup({ inputField: "' + object + '_' + method + '", singleClick: false, ifFormat: "' + DATE_FORMAT + '", button: "' + object + '_' + method + '_trigger" });' )
      end
      str
    end
    
    def js_datetime_select_tag(name, datetime, options = {})
      add_stylesheets('js_calendar')
      add_javascripts('js_calendar/calendar', 'js_calendar/calendar-en', 'js_calendar/calendar-setup')
      content = if datetime.respond_to?(:strftime)
        datetime.strftime(DATETIME_FORMAT)
      elsif datetime.is_a?(String)
        datetime
      elsif options[:default_now]
        Time.zone.now.strftime(DATETIME_FORMAT)
      else
        ''
      end
      new_name = name.to_s.gsub((/(\[([\w]+)\])/)) { |r| "_#{$2}" }
      trigger = new_name + "_trigger"
      str = text_field_tag(name, content, options.merge({ :size => '16' })) +
      '&nbsp;' + image_tag('calendar.gif', { :id => trigger }) +
      '&nbsp;<span style="color: gray; font-size: smaller">example: ' + Time.now.strftime(DATETIME_FORMAT) + '</span>'
      unless options[:disabled]
        str << javascript_tag( 'Calendar.setup({ inputField: "' + new_name + '", singleClick: false, showsTime: true, ifFormat: "' + DATETIME_FORMAT + '", button: "' + trigger + '" });' )
      end
      str
    end
    
    def js_datetime_select(object, method, options = {})
      add_stylesheets('js_calendar')
      add_javascripts('js_calendar/calendar', 'js_calendar/calendar-en', 'js_calendar/calendar-setup')
      str  = text_field(object, method, options.merge({ :size => '16' })) +
      '&nbsp;' + image_tag('calendar.gif', { :id => object + '_' + method + '_trigger' }) +
      '&nbsp;<span style="color: gray; font-size: smaller">example: ' + Time.now.strftime(DATETIME_FORMAT) + '</span>'
      unless options[:disabled]
        str << javascript_tag( 'Calendar.setup({ inputField: "' + object + '_' + method + '", singleClick: false, showsTime: true, ifFormat: "' + DATETIME_FORMAT + '", button: "' + object + '_' + method + '_trigger" });' )
      end
      str
    end
  
  end

  
  module Model
    def self.included(base)
      base.extend ClassMethods
    end    
    
    module ClassMethods
    
      def js_date(*fields)
        fields.each do |f|
          self.class_eval <<-EOF
            def #{f}_cal
              if self.#{f}.is_a?(Date) || self.#{f}.is_a?(Time)
                self.#{f}.strftime(DATE_FORMAT)
              end
            end
          
            def #{f}_cal=(date)
              self.#{f} = Date.strptime(date, DATE_FORMAT) unless date.blank?
            end 
EOF
        end
      end
      
      def js_datetime(*fields)
        fields.each do |f|
          self.class_eval <<-EOF            
            def #{f}_cal
              if self.#{f}.is_a?(Time)
                f.strftime(DATETIME_FORMAT)
              end
            end
          
            def #{f}_cal=(datetime)
              unless datetime.blank?
                self.#{f} = DateTime.strptime(datetime, DATETIME_FORMAT)
              end
            end 
EOF
        end
      end    
    
    end    
  end

end