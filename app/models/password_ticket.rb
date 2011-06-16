class PasswordTicket < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user_id, :value, :expires_at
  validates_uniqueness_of :user_id, :value
  validates_length_of :value, :is => 40

  before_validation_on_create :setup_password_ticket

  def self.get_ticket(value)
    find_by_sql(['SELECT * FROM password_tickets WHERE CAST(value AS BINARY) = ? LIMIT 1;', value])[0]
  end

  def expired?
    expires_at < Time.now
  end

  protected

  def setup_password_ticket
    unless expires_at.is_a?(Time)
      self.expires_at = Time.now + 7.days
    end
    if value.blank? || value.length != 40
      self.value = AppUtils.random_string(40)
    end
  end
end
