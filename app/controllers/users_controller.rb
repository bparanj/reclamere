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
    @list_nav = ListNav.new(params, list_nav,
      { :default_sort_field => 'login',
        :default_sort_direction => 'ASC',
        :limit => PER_PAGE })
    @list_nav.count = User.count(:conditions => @list_nav.conditions, :include => :client)
    @users = User.all(
      :include => :client,
      :conditions => @list_nav.conditions,
      :order      => @list_nav.order,
      :limit      => @list_nav.limit,
      :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def recent
    @users = User.recent
    respond_to do |format|
      format.html # recent.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :text => @user.to_xml(:except => [:breadcrumbs, :crypted_password, :remember_token, :remember_token_expires_at, :salt]) }
    end
  end

  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
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

    respond_to do |format|
      if @user.save
        donemark 'User was successfully created.'
        audit "Created user: \"#{@user.login}\""
        format.html { redirect_to admin_user_path(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    @user.admin = params[:user][:admin] == '1' ? 1 : 0

    respond_to do |format|
      if @user.update_attributes(params[:user])
        audit "Updated user: \"#{@user.login}\""
        donemark 'User was successfully updated.'
        format.html { redirect_to admin_user_path(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
end
