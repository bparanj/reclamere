class SystemMailer < ActionMailer::Base  

  def password_ticket(ticket, sent_at = Time.now)
    tz_name = ticket.user.time_zone.blank? ? Time.zone.name : ticket.user.time_zone

    subject    "#{APPNAME} Password Ticket"
    recipients ticket.user.email
    from       SYSTEM_EMAIL
    body({
        :user_name => ticket.user.name,
        :user_login => ticket.user.login,
        :ticket_link => "#{AppUtils.host}/password_ticket/#{ticket.value}",
        :ticket_expiration => ticket.expires_at.in_time_zone(tz_name).strftime(DATETIME_FORMAT)
      })
    sent_on    sent_at
  end

  # Notify Solution Owner User of pickup request
  # client user initiated
  def pickup_request(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Request"
    recipients pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup request is acknowledged or confirmed
  # solution owner initiated
  def pickup_acknowledgement(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Confirmation"
    recipients pickup.client_user.email
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup notification (reminder)
  # cron initiated
  def pickup_notification(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Reminder"
    recipients pickup.client_user.email
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup arrival notification
  # task initiated
  def pickup_arrived(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Arrival"
    recipients pickup.client_user.email
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup sanitization notification
  # task initiated
  def pickup_sanitized(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Sanitization"
    recipients pickup.client_user.email
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup audit notification
  # task initiated
  def pickup_audited(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Audit"
    recipients(([pickup.client_user] + pickup.client.admins).uniq.map { |r| r.email_address })
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup)
  end

  # Pickup feedback request
  # task initiated
  def pickup_feedback_request(pickup, sent_at = Time.now)
    subject    "#{SOLUTION_OWNER} Pickup Feedback Request"
    recipients pickup.client_user.email
    bcc        pickup.solution_owner_user.email
    from       SYSTEM_EMAIL
    sent_on    sent_at
    body       pickup_mail_data(pickup).merge({
      :feedback_link => "#{AppUtils.host}/feedback_request/#{pickup.feedback.value}", })
  end

  private

  def pickup_mail_data(pickup)
    { :client              => pickup.client,
      :client_user         => pickup.client_user,
      :solution_owner_user => pickup.solution_owner_user,
      :created_by_user     => pickup.created_by,
      :pickup              => pickup,
      :pickup_location     => pickup.pickup_location }
  end

end