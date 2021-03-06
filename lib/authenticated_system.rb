module AuthenticatedSystem
  protected
  # Returns true or false if the user is logged in.
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    !!current_user && !current_user.inactive?
  end

  def solution_owner_user?
    logged_in? && current_user.is_a?(SolutionOwnerUser)
  end

  def client_user?
    logged_in? && current_user.is_a?(ClientUser)
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def solution_owner_admin?
    admin? && solution_owner_user?
  end

  def client_admin?
    admin? && client_user?
  end

  # Accesses the current user from the session.
  # Future calls avoid the database because nil is not equal to false.
  def current_user
    @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
  end

  # Store the given user id in the session.
  def current_user=(new_user)
    session[:user_id] = new_user ? new_user.id : nil
    @current_user = new_user || false
  end

  # Check if the user is authorized
  #
  # Override this method in your controllers if you want to restrict access
  # to only a few actions or if you want to check if the user
  # has the correct rights.
  #
  # Example:
  #
  #  # only allow nonbobs
  #  def authorized?
  #    current_user.login != "bob"
  #  end
  #
  def authorized?(action = action_name, resource = nil)
    logged_in?
  end

  # Filter method to enforce a login requirement.
  #
  # To require logins for all actions, use this in your controllers:
  #
  #   before_filter :login_required
  #
  # To require logins for specific actions, use this in your controllers:
  #
  #   before_filter :login_required, :only => [ :edit, :update ]
  #
  # To skip this in a subclassed controller:
  #
  #   skip_before_filter :login_required
  #
  def login_required
    authorized? || access_denied('You must be logged in.')
  end

  def admin_required
    admin? || access_denied('You must be an administrator.')
  end

  def solution_owner_user_required
    solution_owner_user? || access_denied("You must be a user from #{SOLUTION_OWNER} to access that.")
  end

  def solution_owner_admin_required
    solution_owner_admin? || access_denied("You must be an administrator from #{SOLUTION_OWNER} to access that.")
  end

  def client_user_required
    client_user? || access_denied
  end

  def client_admin_required
    client_admin? || access_denied("You must be an administrator to access that.")
  end

  def access_denied(msg = nil)
    if logged_in?
      warningmark(msg || "Access Denied")
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to '/dashboard'
      end
    else
      infomark "Please log in."
      store_location unless request.request_uri == '/'
      redirect_to "/login"
    end
  end

  # Store the URI of the current request in the session.
  #
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    if base.respond_to? :helper_method
      hm = [ :current_user, :logged_in?, :authorized?, :admin?, :solution_owner_admin?,
        :client_admin?, :solution_owner_user?, :client_user? ]
      base.send :helper_method, *hm
    end
  end

  #
  # Login
  #

  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Called from #current_user.  Now, attempt to login by basic authentication information.
  def login_from_basic_auth
    authenticate_with_http_basic do |login, password|
      self.current_user = User.authenticate(login, password)
    end
  end
    
  #
  # Logout
  #

  # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
  # for the paranoid: we _should_ be storing user_token = hash(cookie_token, request IP)
  def login_from_cookie
    user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
    if user && user.remember_token?
      self.current_user = user
      handle_remember_cookie! false # freshen cookie token (keeping date)
      self.current_user
    end
  end

  # This is ususally what you want; resetting the session willy-nilly wreaks
  # havoc with forgery protection, and is only strictly necessary on login.
  # However, **all session state variables should be unset here**.
  def logout_keeping_session!
    # Kill server-side auth cookie
    @current_user.forget_me if @current_user.is_a? User
    @current_user = false     # not logged in, and don't do it for me
    kill_remember_cookie!     # Kill client-side auth cookie
    session[:user_id] = nil   # keeps the session but kill our variable
    # explicitly kill any other session variables you set
    session[:list_nav] = nil
  end

  # The session should only be reset at the tail end of a form POST --
  # otherwise the request forgery protection fails. It's only really necessary
  # when you cross quarantine (logged-out to logged-in).
  def logout_killing_session!
    logout_keeping_session!
    reset_session
  end
    
  #
  # Remember_me Tokens
  #
  # Cookies shouldn't be allowed to persist past their freshness date,
  # and they should be changed at each login
  def valid_remember_cookie?
    return nil unless @current_user
    (@current_user.remember_token?) &&
      (cookies[:auth_token] == @current_user.remember_token)
  end
    
  # Refresh the cookie auth token if it exists, create it otherwise
  def handle_remember_cookie!(new_cookie_flag)
    return unless @current_user
    case
    when valid_remember_cookie? then @current_user.refresh_token # keeping same expiry date
    when new_cookie_flag        then @current_user.remember_me
    else                             @current_user.forget_me
    end
    send_remember_cookie!
  end
  
  def kill_remember_cookie!
    cookies.delete :auth_token
  end
    
  def send_remember_cookie!
    cookies[:auth_token] = {
      :value   => @current_user.remember_token,
      :expires => @current_user.remember_token_expires_at }
  end

end
