# Copyright (C) 2008 Avalanche, LLC.
# ActsAsFolderable

module ActiveRecord #:nodoc:
  module Acts #:nodoc:
    module Folderable
      
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_folderable
          unless folderable?
            class_eval do              
              has_many :folders, :as => :folderable, :dependent => :destroy
            end
            include ActMethods
          end
        end
          
        def folderable?
          self.included_modules.include?(ActiveRecord::Acts::Folderable::ActMethods)
        end
      end
    
      module ActMethods
        def root_folder_name
          "#{self.class.name.underscore}_#{id}"
        end

        def root_folder(fn = nil, description = nil)
          folder_name = fn || root_folder_name
          folders.find_or_create_by_parent_id_and_name(nil, folder_name) do |f|
            f.description = description
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::Folderable
