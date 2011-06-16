class AppUtils
  
  def self.random_string(length = 40, options = {})
    chars  = []
    chars += ('0'..'9').to_a unless options[:no_digits]
    chars += ('a'..'z').to_a unless options[:no_lower]
    chars += ('A'..'Z').to_a unless options[:no_upper]

    if options[:exclude].is_a?(Array)
      chars.delete_if { |c| options[:exclude].include?(c) }
    end
    (0...length).map { chars[rand(chars.length)] }.join
  end

  def self.host
    "#{SSL ? 'https' : 'http'}://#{APPHOST}"
  end

  def self.storage(*path)
    storage_path = File.join(STORAGE_FOLDER, *path)
    unless File.directory?(storage_path)
      FileUtils.mkdir_p(storage_path)
    end
    storage_path
  end

  def self.rot13(str)
    str.tr("A-Za-z", "N-ZA-Mn-za-m")
  end

  def self.clean_string(str, options = {})
    delimiter = options.delete(:delimiter) || '-'
    d,rd = [delimiter, Regexp.escape(delimiter)]
    str.gsub(/[^#{rd}0-9A-Za-z]/, ' ').strip.downcase.
      gsub(/[#{rd}\s]+/, d).gsub(/^(#{rd})+|(#{rd})+$/, '')
  end

end