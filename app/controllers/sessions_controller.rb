class SessionsController < ApplicationController
  layout 'tigris_nonav'

  def new
  end

  def create
    logout_keeping_session!
    if user = User.authenticate(params[:login], params[:password])
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      donemark "Logged in successfully"
      audit "User #{params[:login]} logged in at #{Time.now}"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    donemark "You have been logged out."
    redirect_to login_path
  end

  def forgot_password
    if logged_in?
      warningmark "You are already logged in as #{current_user.login}."
      redirect_to :controller => '/dashboard', :action => 'index'
    else
      if request.post?
        if user = User.identify(params[:login])
          if user.send_password_ticket
            audit "Requested password ticket", :user => user
            donemark "Password ticket sent to #{user.email}. Please check your email and use the link to log in."
            redirect_to login_path
          else
            errormark "Unable to deliver password ticket."
          end
        else
          @login = params[:login]
          errormark "Unknown login"
        end
      end
    end
  end

  def password_ticket
    if ticket = PasswordTicket.get_ticket(params[:id])
      if logged_in?
        ticket.destroy
        warningmark "You are already logged in as #{current_user.login}. You may update your user information here."
        redirect_to :controller => '/dashboard', :action => 'profile'
      else
        if ticket.expired?
          errormark "The password ticket has expired"
          redirect_to new_session_path
        else
          @user = ticket.user
          if request.post?
            @user.attributes = params[:user]
            if params[:user][:password].blank?
              @user.valid?
              @user.errors.add(:password, "You must supply a password.")
            else
              if @user.save
                ticket.destroy
                reset_session
                self.current_user = @user
                redirect_to :controller => '/dashboard', :action => 'index'
                audit 'Set password with ticket'
                donemark "Welcome #{current_user.name}! You've logged in and set your password using a password ticket. " \
                  "Your user name is #{current_user.login}."
              end
            end
          end
        end
      end
    else
      errormark "Invalid password ticket!"
      redirect_to new_session_path
    end
  end

  def feedback_request
    if feedback = Feedback.get_feedback(params[:id])
      if logged_in?
        if client_user? && feedback.client_user == current_user
          feedback.update_attributes({ :complete => 1 })
          audit "Responded to feedback request"
          infomark "Thank you for taking time to supply us with feedback on our sevices."
          redirect_to edit_pickup_feedback_path(feedback.pickup)
        else
          errormark "Invalid feedback request."
          redirect_to :controller => 'dashboard', :action => 'index'
        end
      else
        feedback.update_attributes({ :complete => 1 })
        reset_session
        self.current_user = feedback.client_user
        audit "Responded to feedback request"
        infomark "Thank you for taking time to supply us with feedback on our sevices."
        redirect_to edit_pickup_feedback_path(feedback.pickup)
      end
    else
      errormark "Invalid feedback request."
      redirect_to "/login"
    end
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    message = "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now}"
    errormark "Couldn't log you in as '#{params[:login]}'"
    warn message
    audit message
  end
end
