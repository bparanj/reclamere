class Admin::DashboardController < ApplicationController
  before_filter :solution_owner_admin_required

  def index
  end

end
