class AuditLogsController < ApplicationController
  before_filter :get_auditable

  def index
    if @auditable
      conditions = ['auditable_type = ? AND auditable_id = ?', @auditable.class.name, @auditable.id]
    else
      conditions = '1'
    end
    @list_nav = ListNav.new(params, list_nav,
      { :default_sort_field => 'audit_logs.created_at',
        :default_sort_direction => 'DESC',
        :limit => PER_PAGE,
        :conditions => conditions })
    @list_nav.count = AuditLog.count(:conditions => @list_nav.conditions, :include => :user)
    @audit_logs = AuditLog.all(:include    => :user,
                               :conditions => @list_nav.conditions,
                               :order      => @list_nav.order,
                               :limit      => @list_nav.limit,
                               :offset     => @list_nav.offset)
    self.list_nav = @list_nav.to_hash
  end

  private

  def get_auditable
    if params[:pickup_id]
      @auditable = Pickup.find(params[:pickup_id])
      if client_user? && @auditable.pickup_location.client != @client
        access_denied
      end
    end
  end

end
