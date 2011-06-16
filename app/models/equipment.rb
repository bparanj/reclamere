class Equipment < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_protected :type, :type_name, :pickup_id, :client_id

  belongs_to :client
  belongs_to :pickup
  belongs_to :created_by,
    :class_name => 'User',
    :foreign_key => :created_by_id

  has_one :pickup_location,
    :through => :pickup

  validates_presence_of :pickup_id, :client_id, :tracking
  validates_uniqueness_of :tracking
  validates_uniqueness_of :serial,
    :allow_nil => true

  before_validation :setup_equipment

  def has_column?(column)
    self.class::ATTRS.include?(column)
  end

  def self.common_attributes(types = nil)
    EquipmentImport::TYPES.inject(nil) do |attrs, type|
      if types.blank? || (types.is_a?(Array) && types.include?(type))
        a = EquipmentImport.equipment_class(type)::ATTRS
        attrs = a if attrs.nil?
        attrs &= a
      end
      attrs
    end
  end

  def self.all_attributes(types = nil)
    EquipmentImport::TYPES.inject(nil) do |attrs, type|
      if types.blank? || (types.is_a?(Array) && types.include?(type))
        a = EquipmentImport.equipment_class(type)::ATTRS
        attrs = a if attrs.nil?
        attrs |= a
      end
      attrs
    end
  end

  # options
  # :start_date (string)
  # :end_date (string)
  # :location_ids (array)
  # :equipment_types (array)
  def self.export_csv(client, options = {})
    errors = []
    select = [
      ['Location',       'pickup_locations.name', 'location_name'],
      ['Pickup',         'pickups.name',          'pickup_name'],
      ['Date',           'pickups.pickup_date',   'pickup_date'],
      ['Equipment Type', 'equipment.type_name',   'type_name']
    ]
    conditions = ['equipment.client_id = ?']
    conditions_attrs = [client.id]
    start_date = nil
    end_date = nil

    unless options[:start_date].blank?
      begin
        start_date = Date.strptime(options[:start_date], DATE_FORMAT)
        conditions << "pickups.pickup_date >= ?"
        conditions_attrs << start_date
      rescue ArgumentError
        errors << "Start date \"#{options[:start_date]}\" is not a valid date format."
      end
    end

    unless options[:end_date].blank?
      begin
        end_date = Date.strptime(options[:end_date], DATE_FORMAT)
        conditions << "pickups.pickup_date <= ?"
        conditions_attrs << end_date
      rescue ArgumentError
        errors << "End date \"#{options[:end_date]}\" is not a valid date format."
      end
    end

    if start_date && end_date
      if start_date > end_date
        errors << "Start date cannot be after end date!"
      end
    end
    
    if options[:location_ids].is_a?(Array) && !options[:location_ids].blank?
      conditions << "pickup_locations.id IN (?)"
      conditions_attrs << options[:location_ids]
    end
    
    if options[:equipment_types].is_a?(Array) && !options[:equipment_types].blank?
      conditions << "equipment.type IN (?)"
      conditions_attrs << options[:equipment_types].map { |etn| EquipmentImport.equipment_class(etn).name }
    end

    all_attributes(options[:equipment_types]).each do |eta|
      unless [:recycling, :value].include?(eta) && options[:client_user]
        select << [eta.to_s.titlecase, "equipment.#{eta.to_s}", eta.to_s]
      end
    end

    if errors.length > 0
      errors
    else
      sql  = "SELECT " + select.map { |s| "#{s[1]} AS #{s[2]}" }.join(', ') + "\n"
      sql << "FROM equipment\n" \
        "INNER JOIN pickups ON equipment.pickup_id = pickups.id\n" \
        "INNER JOIN pickup_locations ON pickup_locations.id = pickups.pickup_location_id\n" \
        "WHERE #{sanitize_sql([conditions.join(' AND ')] + conditions_attrs)}\n" \
        "ORDER BY pickups.pickup_date ASC, pickup_locations.name ASC, equipment.id ASC"
      equipment = find_by_sql(sql)
      if equipment.length > 0
        h = self.new
        str = CSV.generate do |csv|
          csv << select.map { |s| s.first }
          equipment.each do |equip|
            csv << select.map do |s|
              case s.last
              when 'recycling', 'value'
                h.number_to_currency(equip.send(s.last.to_sym))
              else
                equip.send(s.last.to_sym)
              end
            end
          end
        end
        fn = "/tmp/#{AppUtils.random_string(10)}"
        File.open(fn, 'w') { |f| f << str }
        out = %x{ cat "#{fn}" | tr -c '\11\12\40-\176' '\40' }.strip
        FileUtils.rm(fn)
        out
      end

    end
  end

  def self.generate_random_csv_file(equipment_type, outfile, rows = 1000)
    begin
      etc = "PickupEquipment::#{equipment_type.camelcase}".constantize
    rescue NameError
      puts "Invalid equipment type: #{equipment_type}"
    else
      CSV.open(outfile, 'w') do |csv|
        csv << etc::ATTRS.map { |a| a.to_s.titlecase }
        rows.times do
          csv << etc::ATTRS.map do |a|
            case a.to_s
            when 'tracking' # string
              "#{AppUtils.random_string(4)}-#{AppUtils.random_string(8)}"
            when 'serial' # string
              AppUtils.random_string(20)
            when 'mfg' # string
              case rand(3)
              when 0
                'Dell'
              when 1
                'Sun'
              when 2
                'IBM'
              end
            when 'model' # string
              "#{AppUtils.random_string(2, :no_lower => true, :no_digits => true)}-#{rand(10000)}"
            when 'comments' # string
              case rand(3)
              when 0
                'Everything looks good!'
              when 1
                'Some worn edges.'
              when 2
                'It is in bad shape.'
              end
            when 'country'
              rand(6) == 0 ? 'CA' : 'US'
            when 'location'
              "Location \##{rand(10) + 1}"
            when 'grade' # string
              v = ('A'..'F').to_a[rand(6)]
              v
            when 'recycling' # integer
              "$#{rand(100)}.#{rand(100)}"
            when 'value' # integer
              "$#{rand(10000)}.#{rand(100)}"
            when 'processor' # string
              "#{rand(3)}.#{rand(100)} GHz"
            when 'hard_drive' # string
              "#{rand(100)} GBs"
            when 'ram' # string
              "#{rand(10)} GBs"
            when 'page_count' # integer
              "#{rand(10000) + 1000}"
            when 'screen_size' # string
              "#{rand(30)} x #{rand(30)}"
            when 'mfg_date' # string
              (Date.today - rand(1000)).to_s
            when 'disposition' # string
              case rand(4)
              when 0
                'refurbished'
              when 1
                'recycled'
              when 2
                'remarket'
              when 3
                'return'
              end
            when 'customer' # string
              "Customer \##{rand(10) + 1}"
            when 'asset_tag' # string
              AppUtils.random_string(8, :no_lower => true)
            when 'piu', 'dws_cart', 'cpu', 'monitors', 'bob', 'bob_cable'
              "#{AppUtils.random_string(4, :no_lower => true)}-#{AppUtils.random_string(12, :no_lower => true)}-#{AppUtils.random_string(8, :no_lower => true)}"
            else
              nil
            end
          end
        end
      end
      outfile
    end
  end

  private

  def setup_equipment
    if pickup
      self.client = pickup.client
    end
    self.type_name = self.class.name.split("::").last
  end
end
