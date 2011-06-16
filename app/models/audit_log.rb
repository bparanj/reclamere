class AuditLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :auditable,
    :polymorphic => true

  validates_presence_of :user_id, :request_uri, :remote_addr, :description

  before_validation :process_audit_log

  def process_audit_log
    if request_uri && request_uri.match(/[\w]{40,}$/)
      self.request_uri = request_uri.gsub(/[\w]+$/, '###')
    end
  end
end
