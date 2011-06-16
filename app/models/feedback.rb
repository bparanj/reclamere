class Feedback < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :client_user
  belongs_to :updated_by,
    :class_name => 'ClientUser',
    :foreign_key => 'updated_by_id'

  named_scope :recent,
    :conditions => ['pickups.status = ? AND ' \
      '(  contacted_promptly        IS NOT NULL ' \
      'OR complete_audit_timely     IS NOT NULL ' \
      'OR appropriate_communication IS NOT NULL ' \
      'OR customer_service_needs    IS NOT NULL ' \
      'OR comments                  IS NOT NULL ' \
      'OR solution_owner_contact    IS NOT NULL ' \
      'OR `feedbacks`.`references`  IS NOT NULL)',
        "Closed"],
    :order => 'updated_at DESC',
    :limit => 5,
    :include => :pickup

  validates_presence_of :pickup_id, :client_user_id, :value, :complete
  validates_uniqueness_of :value
  validates_length_of :value, :is => 40
  validates_inclusion_of :complete, :in => [0,1]
  validates_inclusion_of :solution_owner_contact,
    :in => [0,1],
    :allow_blank => true
  [:contacted_promptly,:complete_audit_timely,:appropriate_communication,:customer_service_needs].each do |attr|
    validates_inclusion_of attr, :in => 1..5, :allow_blank => true
  end

  before_validation :setup_feedback

  def self.get_feedback(value)
    find_by_sql(['SELECT * FROM feedbacks WHERE CAST(value AS BINARY) = ? AND complete = ? LIMIT 1;', value, 0])[0]
  end

  def average_score
    vals = []
    [:contacted_promptly, :complete_audit_timely, :appropriate_communication, :customer_service_needs].each do |attr|
      if t = send(attr)
        vals << t.to_f
      end
    end
    if vals.length > 0
      average = vals.inject(0.0) { |total,value| total += value } / vals.length.to_f
      sprintf "%.1f", average
    else
      'None'
    end
  end

  private

  def setup_feedback
    unless value.is_a?(String) && value.length == 40
      self.value = AppUtils.random_string(40)
    end
    unless client_user
      self.client_user = pickup.client_user
    end
  end
end
