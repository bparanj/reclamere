class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  #local_addresses.clear
  include AuthenticatedSystem
  include Messaging

  # before_filter :check_login, :set_time_zone, :ensure_proper_protocol

  layout 'tigris'

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '68282f54812348c46bca67434ec2d30d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :key

  protected

  exception_data :additional_data

  def additional_data
    { :current_user => current_user }
  end

  private
  
  def admin_controller?
    params[:controller].match(/^admin/) || request.path.match(/^\/admin/)
  end

  def check_login
    if params[:controller] != 'sessions'
      if admin_controller?
        solution_owner_admin_required
      else
        login_required
      end
    end
    @client = current_user.client if client_user?
  end

  def audit(description, options = {})
    al = AuditLog.new({
        :request_uri  => request.request_uri,
        :remote_addr  => request.remote_addr,
        :user         => options[:user] || current_user,
        :description  => description,
        :auditable    => options[:auditable] })
    return al if al.save
    warn "Unable to save audit information: #{al.errors.inspect}"
  end

  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end

  def ensure_proper_protocol
    return true if Rails.env == "development" 
    if (SSL ^ request.ssl?)
      redirect_to "#{AppUtils.host}#{request.request_uri}"
      flash.keep
      return false
    end
  end
  
  def render_to_pdf(options = nil)
    data = render_to_string(options)
    pdf = PDF::HTMLDoc.new
    pdf.set_option :bodycolor, :white
    pdf.set_option :toc, false
    pdf.set_option :portrait, true
    pdf.set_option :links, false
    pdf.set_option :webpage, true
    pdf.set_option :left, '2cm'
    pdf.set_option :right, '2cm'
    pdf << data
    pdf.generate
  end
end
