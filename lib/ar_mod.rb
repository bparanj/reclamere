# Copyright (C) 2008 Avalanche, LLC.

class ActiveRecord::Base
  alias_method :original_new_record?, :new_record?
  def new_record?
    return original_new_record? if [true,false].include?(original_new_record?)
    (defined?(@new_record) || false) && (@new_record || false)
  end
end