class ClientUser < User
  validates_presence_of :client_id
end
