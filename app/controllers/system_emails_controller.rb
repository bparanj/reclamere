class SystemEmailsController < ApplicationController
  before_filter :get_pickup

  # GET /pickups/:pickup_id/system_emails
  # GET /pickups/:pickup_id/system_emails.xml
  def index
    @system_emails = @pickup.system_emails.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @system_emails }
    end
  end

  # GET /pickups/:pickup_id/system_emails/1
  # GET /pickups/:pickup_id/system_emails/1.xml
  def show
    @system_email = @pickup.system_emails.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @system_email }
    end
  end

  private

  def get_pickup
    @pickup = Pickup.find(params[:pickup_id])
    access_denied if client_user? && @pickup.client != @client
  end
end
