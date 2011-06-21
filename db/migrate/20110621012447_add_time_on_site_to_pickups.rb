class AddTimeOnSiteToPickups < ActiveRecord::Migration
  def self.up
    add_column(:pickups, :facility, :string)
    add_column(:pickups, :arrival_time, :string)
    add_column(:pickups, :departure_time, :string)
    add_column(:pickups, :number_of_men, :string)
    add_column(:pickups, :crew_members, :text)
  end

  def self.down
  end
end


