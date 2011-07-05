class Peripheral < ActiveRecord::Base
  has_many :peripherals_hard_drive_serials
  belongs_to :pickup

  DROP_DOWN_LIST = ["Please select","Printer", "Fax", "Scanner"]  
end
