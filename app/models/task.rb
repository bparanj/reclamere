class Task < ActiveRecord::Base
  TASK_NAMES = ['Picked Up', 'Arrived', 'Sanitized', 'Audited', 'Invoiced', 'Feedback']
  TASK_STATUSES = ['Open', 'Not Required', 'Complete']

  belongs_to :pickup
  belongs_to :solution_owner_user

  validates_presence_of :pickup_id, :num, :name, :status
  validates_presence_of :solution_owner_user_id, :unless => Proc.new { |task| task.status == 'Open' }
  validates_uniqueness_of :num, :scope => :pickup_id
  validates_uniqueness_of :name, :scope => :pickup_id
  validates_inclusion_of :status, :in => TASK_STATUSES
  validates_inclusion_of :name, :in => TASK_NAMES

  def update_status(task_status, task_user, comments = nil)
    transaction do
      self.status = task_status
      self.solution_owner_user = task_user
      self.comments = comments
      case name
      when 'Picked Up'
        pickup.status = 'Picked Up'
      when 'Arrived'
        pickup.status = 'Arrived'
      when 'Sanitized'
        pickup.status = 'Sanitized'
      when 'Audited'
        pickup.status = 'Audited'
      when 'Invoiced'
        pickup.status = 'Invoiced'
      when 'Feedback'
        if status == 'Complete'
          pickup.status = 'Feedback'
        else
          pickup.status = 'Closed'
        end
      end
      raise ActiveRecord::Rollback unless pickup.save
      raise ActiveRecord::Rollback unless save
      pickup.send_system_email if status == 'Complete'
      true
    end
  end
end
