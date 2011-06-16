class FeedbacksController < ApplicationController
  before_filter :get_feedback
  before_filter :feedback_editor_required, :only => [ :edit, :update ]
  before_filter :feedback_viewer_required, :only => [ :show ]

  # GET /pickups/:pickup_id/feedback
  # GET /pickups/:pickup_id/feedback.xml
  def show
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feedback }
    end
  end

  def edit
  end

  # PUT /pickups/:pickup_id/feedback
  def update
    if @pickup.status == 'Feedback'
      @feedback.attributes = params[:feedback]
      if @feedback.changed?
        @feedback.updated_by = current_user
        ret = Feedback.transaction do
          raise ActiveRecord::Rollback unless @feedback.save
          @pickup.status = 'Closed'
          raise ActiveRecord::Rollback unless @pickup.save
          true
        end
        if ret
          donemark 'Thank you for your feedback.'
          audit "Submitted feedback for pickup \"#{@pickup.name}\"", :auditable => @pickup
          redirect_to pickup_path(@pickup)
        else
          @pickup.status = 'Feedback'
          render :action => "edit"
        end
      end
    else
      access_denied
    end
  end

  private

  def can_edit_feedback?
    client_user? && @pickup.client == @client && @pickup.status == 'Feedback'
  end

  def can_view_feedback?
    if solution_owner_user?
      ['Feedback', 'Closed'].include?(@pickup.status)
    else
      ['Feedback', 'Closed'].include?(@pickup.status) &&
        @pickup.client == @client
    end
  end

  def feedback_editor_required
    can_edit_feedback? || access_denied
  end

  def feedback_viewer_required
    can_view_feedback? || access_denied
  end

  def get_feedback
    @pickup = Pickup.find(params[:pickup_id])
    @feedback = @pickup.feedback
  end
end
