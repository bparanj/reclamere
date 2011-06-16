require 'list_nav'
require 'list_nav_helper'

ActionController::Base.send :include, ListNavigator
ActionView::Base.send       :include, ListNavHelper
