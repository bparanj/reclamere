# Copyright (C) 2008 Avalanche, LLC.

module Cron

  SEND_NOTIFICATIONS = false
  RECIPIENT = 'bparanj@gmail.com'
  #RECIPIENT = '9522004969@tmomail.net'
  #RECIPIENT = 'andrew@avalanche.coop'

  def self.daily
    t = Time.zone.now.strftime('%Y-%m-%d %I:%M%p')
    RAILS_DEFAULT_LOGGER.error("CRON START DAILY - #{t} (#{RAILS_ENV})")
    Pickup.send_notifications
    RAILS_DEFAULT_LOGGER.error("CRON END DAILY - #{t} (#{RAILS_ENV})")
    RAILS_DEFAULT_LOGGER.flush if RAILS_ENV == 'production'
    #notify_of_cron 'daily'
    true
  end
  
  def self.weekly
    #notify_of_cron 'weekly'
  end
  
  def self.monthly
    #notify_of_cron 'monthly'
  end
  
  # Use this command to generate a sample crontab file
  def self.crontab
    r = %x[ which ruby ].strip
    puts "# m h dom mon dow command\n" \
      "0 1 * * * #{r} " + File.expand_path(RAILS_ROOT) + "/script/runner -e #{RAILS_ENV} 'Cron.daily'\n" \
      "0 2 * * 6 #{r} " + File.expand_path(RAILS_ROOT) + "/script/runner -e #{RAILS_ENV} 'Cron.weekly'\n" \
      "0 3 1 * * #{r} " + File.expand_path(RAILS_ROOT) + "/script/runner -e #{RAILS_ENV} 'Cron.monthly'"
  end

  private

  def self.notify_of_cron(str)
    if SEND_NOTIFICATIONS
      %x{ echo '#{APPNAME} #{str} cron executed.' | mailx -e -s '#{APPNAME} #{str} cron' #{RECIPIENT} }
    end
  end

end