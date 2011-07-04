class Pickup < ActiveRecord::Base
  
  # old STATUSES = ['Requested', 'Acknowledged', 'Notified', 'Picked Up', 'Arrived', 'Invoiced', 'Closed']
  STATUSES = ['Picked Up', 'Arrived', 'IR', 'DDD', 'Invoiced']
  
  PICKUP_TYPES = [['Digital Data Destruction', 'Digital Data Destruction' ],
  ['Physical Data Destruction', 'Physical Data Destruction'],
  ['Inventory Report', 'Inventory Report'], 
  ['Certified Asset Tag Removal', 'Certified Asset Tag Removal'],
  ['Environment Lot Certificate', 'Environment Lot Certificate'], 
  ['Magnetic Media Incineration', 'Magnetic Media Incineration'],
  ['Hard Drive Screening Report', 'Hard Drive Screening Report']
  ]

  attr_protected :client_id, :status

  has_many :equipment, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :system_emails, :dependent => :destroy
  has_one :feedback, :dependent => :destroy
  
  has_many :pallets
  has_many :computer_monitors
  has_many :cpus
  has_many :loose_hard_drive
  has_many :flash_hard_drive
  has_many :tvs
  has_many :magnetic_medias
  has_many :peripherals
  has_many :miscellaneous_equipments
  
  belongs_to :pickup_location
  belongs_to :client
  belongs_to :solution_owner_user
  belongs_to :client_user
  belongs_to :created_by, :class_name => 'User',  :foreign_key => 'created_by_id'

  acts_as_folderable

  js_date :pickup_date, :notification_date

  validates_presence_of :pickup_location_id, :client_id, :status, :client_user_id, :solution_owner_user_id
  validates_presence_of :name
  validates_presence_of :pickup_date
  validates_presence_of :notification_date
  validates_uniqueness_of :name, :scope => :pickup_location_id, :allow_blank => true
  validates_inclusion_of :status, :in => STATUSES

  def validate
    if client && pickup_location && client != pickup_location.client
      errors.add(:client_id, 'does not have this location.')
    end
    if client && client_user && client != client_user.client
      errors.add(:client_user_id, 'Client lead is not from this client.')
    end
    if status &&  pickup_date && pickup_date < Date.today
      errors.add(:pickup_date, 'must not be in the past.')
    end
    if pickup_date && notification_date && notification_date > pickup_date
      errors.add(:notification_date, "cannot be after pickup date.")
    end
  end

  before_validation :setup_pickup
  after_create :setup_tasks
  after_create :feedback
  
  # manually approve pickup request
  def acknowledge_pickup
    transaction do
      self.status = 'Acknowledged'
      raise ActiveRecord::Rollback unless save
      send_system_email
      true
    end
  end
  
  # notify of pickup from cron
  def notify_pickup(cron_triggered = true)
    transaction do
      self.status = 'Notified'
      raise ActiveRecord::Rollback unless save
      if cron_triggered
        # Must manually create audit log for cron job executed functions
        a = AuditLog.new({
            :request_uri  => "/pickups/#{id}",
            :remote_addr  => "127.0.0.1",
            :user         => solution_owner_user,
            :description  => "System notified client of upcoming pickup",
            :auditable    => self })
        raise ActiveRecord::Rollback unless a.save
      end
      send_system_email
      true
    end
  end
  # TODO : This needs to be updated based on required status 
  def send_system_email
    mail = case status
    when 'Requested'
      SystemMailer.create_pickup_request(self)
    when 'Acknowledged'
      SystemMailer.create_pickup_acknowledgement(self)
    when 'Notified'
      SystemMailer.create_pickup_notification(self)
    when 'Arrived'
      SystemMailer.create_pickup_arrived(self)
    when 'Sanitized'
      SystemMailer.create_pickup_sanitized(self)
    when 'Audited'
      SystemMailer.create_pickup_audited(self)
    when 'Feedback'
      SystemMailer.create_pickup_feedback_request(self)
    else
      nil
    end
    if mail
      se = system_emails.new({
          :user => User.find_by_email(mail.to[0]),
          :subject => mail.subject,
          :body => mail.body
        })
      if se.save
        SystemMailer.deliver(mail)
      else
        raise ActiveRecord::Rollback
      end
    end
  end

  # Send today's notifications for all acknowledged pickups
  def self.send_notifications(date = nil)
    date ||= Date.today
    all(:conditions => ['status = ? AND notification_date = ?', 'Acknowledged', date]).each do |p|
      p.notify_pickup
    end
  end

  def current_task
    tasks.first(:order => 'num ASC', :conditions => ['status != ? AND status != ?', 'Not Required', 'Complete'])
  end

  alias_method :original_feedback, :feedback
  def feedback
    original_feedback || create_feedback
  end

  def equipment_import_folder
    root_folder('Equipment Import', 'Equipment Import Folder')
  end

  private

  def setup_tasks
    ret = true
    Task::TASK_NAMES.each_with_index do |task_name, task_num|
      unless t = tasks.first(:conditions => { :name => task_name, :num => task_num })
        t = Task.new
        t.pickup = self
        t.name = task_name
        t.num = task_num
        t.status = 'Open'
        t.solution_owner_user = solution_owner_user
        ret = false unless t.save
      end
    end
    ret
  end

  def setup_pickup
    self.client = pickup_location.client if pickup_location
    # Set notification_date
    if pickup_date && !notification_date
      nd = pickup_date - 2.days
      while [6,7].include?(nd.cwday) # nd falls on the weekend
        nd -= 1.day
      end
      if Date.today < pickup_date && Date.today > nd
        self.notification_date = Date.today
      else
        self.notification_date = nd
      end
    end
  end
end
