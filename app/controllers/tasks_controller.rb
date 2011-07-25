class TasksController < ApplicationController
  before_filter :solution_owner_user_required, :only => :update
  before_filter :get_pickup

  # GET /pickup/:pickup_id/tasks
  def index
    @tasks = @pickup.tasks.all(:order => 'num ASC')
  end
  # TODO : Trigger notification emails when the status changes
  # PUT /pickup/:pickup_id/tasks/1
  def update
    @task = @pickup.tasks.find(params[:id])

    if @task.update_status(params[:commit], current_user, params[:task][:comments])
      donemark "#{@task.name} #{@task.status}."
      audit "Pickup \"#{@pickup.name}\" task #{@task.name} #{@task.status}", :auditable => @pickup
    else
      errormark "Unable to update task."
    end

    redirect_to :action => 'index'
  end

  private

  def get_pickup
    @pickup = Pickup.find(params[:pickup_id])
    @current_task = @pickup.current_task
    
    if client_user?
      if @pickup.client == @client
        @can_update = false
      else
        access_denied
      end
    else
      @can_update = @current_task && !['Requested', 'Acknowledged'].include?(@pickup.status)
    end
  end
end
