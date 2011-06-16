class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  belongs_to :client
  has_one :password_ticket
  serialize :breadcrumbs
  attr_accessor :send_password_ticket_flag

  named_scope :recent,
    :include => :client,
    :order => 'last_login DESC',
    :limit => PER_PAGE,
    :conditions => 'last_login IS NOT NULL'

  validates_presence_of :type, :login, :email, :name, :admin, :inactive

  validates_length_of       :login,    :within => 3..255
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 255
  validates_uniqueness_of   :name

  validates_length_of       :email,    :within => 6..255 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation,
    :client_id, :title, :phone, :time_zone, :send_password_ticket_flag

  before_validation_on_create :setup_breadcrumbs
  after_save :process_send_password_ticket_flag

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    search = login.match(Authentication.email_regex) ? :email : :login
    u = find(:first, :conditions => { search => login, :inactive => 0 })
    if u && u.authenticated?(password)
      u.update_attribute('last_login', Time.now)
      u
    else
      nil
    end
  end

  def self.identify(login)
    return nil if login.blank?
    search = login.match(Authentication.email_regex) ? :email : :login
    find(:first, :conditions => { search => login, :inactive => 0 })
  end

  def send_password_ticket
    unless inactive?
      PasswordTicket.transaction do
        if password_ticket
          password_ticket.update_attributes({
              :value => AppUtils.random_string(40),
              :expires_at => Time.now + 7.days
            })
        else
          raise ActiveRecord::Rollback unless create_password_ticket
        end
        SystemMailer.deliver_password_ticket(password_ticket)
        return true
      end
    end
    false
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def email_address
    "\"#{name}\" <#{email}>"
  end

  def admin?
    admin == 1
  end

  def inactive?
    inactive == 1
  end

  def toggle_inactivity
    update_attribute :inactive, (inactive? ? 0 : 1)
  end

  def add_breadcrumb(name, path)
    if breadcrumbs.is_a?(Array)
      new_bc = breadcrumbs.reject { |b| b[1] == path }
      new_bc.unshift([name, path])
    else
      new_bc = [[name, path]]
    end
    update_attribute('breadcrumbs', new_bc[0..7])
  end

  protected
    
  def setup_breadcrumbs
    unless breadcrumbs.is_a?(Array)
      self.breadcrumbs = []
    end
  end

  def process_send_password_ticket_flag
    if send_password_ticket_flag.to_i == 1
      send_password_ticket
    end
    self.send_password_ticket_flag = nil
  end

end
