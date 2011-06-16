class SystemEmail < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :user

  validates_presence_of :pickup_id, :user_id, :subject

  before_save :clean_body

  private

  def clean_body
    unless body.blank?
      str = "#{AppUtils.host}/feedback_request/"
      regexp = Regexp.escape(str) + '[\w]{40,40}'
      self.body = body.gsub(/#{regexp}/, str + '###')
    end
  end
end
