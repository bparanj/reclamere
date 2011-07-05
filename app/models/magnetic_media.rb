class MagneticMedia < ActiveRecord::Base
  belongs_to :pickup
  
  DROP_DOWN_LIST = ["Please select","Floppy", "CD", "Media"]
end
