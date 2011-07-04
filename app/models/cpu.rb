class Cpu < ActiveRecord::Base
  has_many :cpu_hard_drive_serials
  belongs_to :pickup
  
end
