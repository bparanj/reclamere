class UsersController < ApplicationController
  
  def index
    if params[:commit] == 'Toggle Inactivity' && params[:user_ids].is_a?(Array)
      params[:user_ids].each do |id|
        user = User.find(id)
        if user != current_user
          user.toggle_inactivity
          msg = "#{user.login} was made #{user.inactive? ? 'in' : ''}active"
          donemark msg
          audit msg
        end
      end
    end
    @list_nav = ListNav.new(params, list_nav, { :default_sort_field => 'login',
                                                :default_sort_direction => 'ASC',
                                                :limit => PER_PAGE })
    @list_nav.count = User.count(:conditions => @list_nav.conditions, :include => :client)
    @users = User.all(:include => :client,
                      :conditions => @list_nav.conditions,
                      :order      => @list_nav.order,
                      :limit      => @list_nav.limit,
                      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash
  end

  def recent
    @users = User.recent
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = if params[:user][:client_id].blank?
      SolutionOwnerUser.new(params[:user])
    else
      ClientUser.new(params[:user])
    end
    @user.admin = 1 if params[:user][:admin] == '1'
    
    if @user.save
      donemark 'User was successfully created.'
      audit "Created user: \"#{@user.login}\""
      redirect_to admin_user_path(@user)
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.admin = params[:user][:admin] == '1' ? 1 : 0
    
    if @user.update_attributes(params[:user])
      audit "Updated user: \"#{@user.login}\""
      donemark 'User was successfully updated.'
      redirect_to admin_user_path(@user)
    else
      render :action => "edit"
    end

  end
end
