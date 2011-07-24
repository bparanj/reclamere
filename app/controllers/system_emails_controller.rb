class SystemEmailsController < ApplicationController
  before_filter :get_pickup

  # GET /pickups/:pickup_id/system_emails
  def index
    @system_emails = @pickup.system_emails.find(:all, :order => 'created_at DESC')
  end

  # GET /pickups/:pickup_id/system_emails/1
  def show
    @system_email = @pickup.system_emails.find(params[:id])
  end

  private

  def get_pickup
    @pickup = Pickup.find(params[:pickup_id])
    access_denied if client_user? && @pickup.client != @client
  end
end
