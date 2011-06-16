class PickupLocation < ActiveRecord::Base
  include Address

  has_many :pickups, :dependent => :destroy

  belongs_to :client
  belongs_to :client_user
  belongs_to :solution_owner_user

  validates_presence_of :client_id, :client_user_id, :solution_owner_user_id
  validates_uniqueness_of :name, :scope => :client_id

  def validate
    if client && client_user
      if client != client_user.client
        errors.add(:client_user_id, "is not a user from this client.")
      end
    end
  end
end
