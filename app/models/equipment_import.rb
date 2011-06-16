class EquipmentImport
  TYPES = ['PCs', 'Laptops', 'Servers', 'Monitors', 'Printers', 'Miscellaneous',
    'EE3000s', 'PIUs', 'DWS Carts', 'CPUs', 'ES Monitors', 'BOBs', 'BOB Cables']

  attr_reader :pickup, :document, :type, :results, :errors, :unimported_document,
    :num_imported, :num_unimported

  def initialize(pickup, document, type, current_user)
    @pickup = pickup
    @document = document
    @type = type
    @current_user = current_user
    unless TYPES.include?(@type)
      @errors ||= []
      @errors << 'Invalid Equipment Type'
    end
    @saved = false
    csv
  end

  def saved?
    @saved ? true : false
  end

  def valid?
    @errors.blank?
  end

  def csv
    @csv ||= begin
      CSV.parse(@document.content)
    rescue CSV::MalformedCSVError => e
      @errors ||= []
      @errors << 'Unable to parse CSV document'
      warn "Equipment CSV import error\ndocument: #{@document.id}"
      []
    end
  end

  def unimported_data
    if unimported_document
      @unimported_data ||= begin
        CSV.parse(unimported_document.content)
      rescue CSV::MalformedCSVError => e
        warn "Unimported equipment import CSV error\ndocument: #{unimported_document.id}"
        []
      end
    end
  end

  def save(map = {})
    if valid?
      @saved = true
      @num_imported = 0
      @num_unimported = 0
      unimported = CSV.generate do |ui|
        csv.each_with_index do |data, i|
          if i == 0
            ui << data + ['Errors']
          else
            e = equipment_class.new
            e.pickup = @pickup
            e.created_by_id = @current_user.id
            map.each do |column,attr|
              unless column.blank? || attr.blank? || data[column.to_i].blank?
                if ['recycling', 'value', 'page_count'].include?(attr)
                  e.send(:"#{attr}=", data[column.to_i].to_s.strip.gsub(/[\$, ]+/, '').to_f.round)
                else
                  e.send(:"#{attr}=", data[column.to_i].to_s.strip)
                end
              end
            end
            if e.save
              @num_imported += 1
            else
              ui << data + [e.errors.full_messages.join(", ")]
              @num_unimported += 1
            end
          end
        end
      end
      if @num_unimported > 0
        create_unimported_document(unimported)
      end
      true
    else
      false
    end
  end
  
  def columns
    equipment_class::ATTRS
  end

  def self.import_document_name(type, folder)
    num_ar = folder.documents.map do |d|
      if m = d.name.match(/^Equipment Import ([\d]+) \([\w]+\)$/)
        m[1].to_i
      end
    end.compact
    if num_ar.length > 0
      num = num_ar.max + 1
    else
      num = 1
    end
    "Equipment Import #{num} (#{type})"
  end

  def self.upload_import_document(type, document, pickup, user)
    d = Document.new(document)
    if TYPES.include?(type)
      f = pickup.equipment_import_folder
      d.name = import_document_name(type, f)
      d.folder = f
      d.created_by = user
      d.save
    else
      d.errors.add_to_base "Please select an equipment type."
    end
    d
  end

  def self.equipment_class(type)
    case type
    when 'PCs'
      PickupEquipment::Pc
    when 'Laptops'
      PickupEquipment::Laptop
    when 'Servers'
      PickupEquipment::Server
    when 'Monitors'
      PickupEquipment::Monitor
    when 'Printers'
      PickupEquipment::Printer
    when 'Miscellaneous'
      PickupEquipment::Misc
    when 'EE3000s'
        PickupEquipment::Ee3000
    when 'PIUs'
      PickupEquipment::Piu
    when 'DWS Carts'
      PickupEquipment::DwsCart
    when 'CPUs'
      PickupEquipment::Cpu
    when 'ES Monitors'
      PickupEquipment::EsMonitor
    when 'BOBs'
      PickupEquipment::Bob
    when 'BOB Cables'
      PickupEquipment::BobCable
    end
  end

  private

  def equipment_class
    self.class.equipment_class(@type)
  end

  def create_unimported_document(unimported)
    u = @document.clone
    new_name = "#{u.name} - Failed Rows "
    while u.folder.documents.exists?({ :name => new_name })
      new_name << AppUtils.random_string(1)
    end
    u.name = new_name
    u.description = "Failed rows from #{@document.name}"
    u.version = 1
    u.filename.gsub!(/\.csv$/i, '-unimported.csv')
    u.content = unimported
    @unimported_document = u.save ? u : nil
  end

end