desc "Create admin solution owner user"

task :create_admin => :environment do
  u = User.new
  u.login = "bparanj"
  u.email = "bparanj@gmail.com"
  u.type = "SolutionOwnerUser"
  u.name = "Bala"
  u.admin = 1
  u.password = "nikki13"
  u.password_confirmation = "nikki13"
  u.save
end