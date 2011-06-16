class ActiveRecord::Errors
  def full_messages
    full_messages = []

    @errors.each_key do |attr|
      @errors[attr].each do |msg|
        next if msg.nil?

        if attr == "base" || msg.to_s.match(/^[A-Z]/)
          full_messages << msg.to_s
        else
          full_messages << [attr.humanize, msg].join(' ')
        end
      end
    end
    full_messages
  end
end