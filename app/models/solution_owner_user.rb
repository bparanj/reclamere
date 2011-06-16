class SolutionOwnerUser < User
  def validate
    unless client_id.blank?
      errors.add(:client_id, "must be blank.")
    end
  end
end
