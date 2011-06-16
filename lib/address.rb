module Address

  STATES = [
    ["Alabama", "AL"],
    ["Alaska", "AK"],
    ["American Samoa", "AS"],
    ["Arizona", "AZ"],
    ["Arkansas", "AR"],
    ["California", "CA"],
    ["Colorado", "CO"],
    ["Connecticut", "CT"],
    ["Delaware", "DE"],
    ["District of Columbia", "DC"],
    ["Federated States of Micronesia", "FM"],
    ["Florida", "FL"],
    ["Georgia", "GA"],
    ["Guam", "GU"],
    ["Hawaii", "HI"],
    ["Idaho", "ID"],
    ["Illinois", "IL"],
    ["Indiana", "IN"],
    ["Iowa", "IA"],
    ["Kansas", "KS"],
    ["Kentucky", "KY"],
    ["Louisiana", "LA"],
    ["Maine", "ME"],
    ["Marshall Islands", "MH"],
    ["Maryland", "MD"],
    ["Massachusetts", "MA"],
    ["Michigan", "MI"],
    ["Minnesota", "MN"],
    ["Mississippi", "MS"],
    ["Missouri", "MO"],
    ["Montana", "MT"],
    ["Nebraska", "NE"],
    ["Nevada", "NV"],
    ["New Hampshire", "NH"],
    ["New Jersey", "NJ"],
    ["New Mexico", "NM"],
    ["New York", "NY"],
    ["North Carolina", "NC"],
    ["North Dakota", "ND"],
    ["Northern Mariana Islands", "MP"],
    ["Ohio", "OH"],
    ["Oklahoma", "OK"],
    ["Oregon", "OR"],
    ["Palau", "PW"],
    ["Pennsylvania", "PA"],
    ["Puerto Rico", "PR"],
    ["Rhode Island", "RI"],
    ["South Carolina", "SC"],
    ["South Dakota", "SD"],
    ["Tennessee", "TN"],
    ["Texas", "TX"],
    ["Utah", "UT"],
    ["Vermont", "VT"],
    ["Virgin Islands", "VI"],
    ["Virginia", "VA"],
    ["Washington", "WA"],
    ["West Virginia", "WV"],
    ["Wisconsin", "WI"],
    ["Wyoming", "WY"]]

  def self.included(base) # :nodoc:
    base.extend ClassMethods
    base.setup_address
  end

  module ClassMethods
    class_eval do
      def setup_address
        attr_protected :lat, :lng

        validates_presence_of :name, :address_1, :city, :state
        validates_length_of :state, :is => 2
        validates_format_of :postal_code,
          :with => /^[\d]{5,5}(\-[\d]{4,4})?$/,
          :message => 'must be of the format ##### or #####-####.',
          :allow_blank => true
        validates_inclusion_of :state,
          :in => STATES.map { |s| s[1] }

        before_save :geocode
      end
    end
  end

  def state_name
    unless state.blank?
      STATES.detect { |s| s[1] == state }[0]
    end
  end

  def address_card
    str  = "#{name}\n"
    str << "#{address_1}\n"
    str << "#{address_2}\n" unless address_2.blank?
    str << "#{city}, #{state}"
    str << " #{postal_code}" unless postal_code.blank?
    str
  end
  
  def address_string
    "#{address_1}, #{city}, #{state}" + (postal_code.blank? ? '' : ' ' + postal_code)
  end

  def geocoded?
    !lat.blank? && !lng.blank?
  end

  def geocode
    if address_1_changed? || city_changed? || state_changed? || postal_code_changed?
      res = Geokit::Geocoders::MultiGeocoder.geocode(ERB::Util.html_escape(address_string))
      if res.success
        self.postal_code = res.zip if postal_code.blank?
        self.lat = res.lat
        self.lng = res.lng
      end
    end
  end

end