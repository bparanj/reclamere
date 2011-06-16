require 'js_calendar'

ActiveRecord::Base.send :include, JsCalendar::Model
ActionView::Base.send :include, JsCalendar::Helper