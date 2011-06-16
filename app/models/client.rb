class Client < ActiveRecord::Base
  include Address

  acts_as_folderable

  has_many :pickup_locations, :dependent => :destroy
  has_many :pickups, :dependent => :destroy
  has_many :client_users
  has_many :equipment, :dependent => :destroy

  validates_uniqueness_of :name

  def admins
    client_users.all(:conditions => ['admin = ?', 1])
  end

  def abbrev
    words = name.upcase.gsub(/[^0-9A-Za-z ]/, '').split(/[\s]/)
    if words.length == 1
      words[0][0..1]
    else
      words[0][0..0] + words[1][0..0]
    end
  end
end
