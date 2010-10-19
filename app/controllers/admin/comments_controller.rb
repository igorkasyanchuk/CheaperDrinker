class Admin::CommentsController < Admin::DashboardController
  belongs_to :location, :optional => true
  
  def index
    index!
    if @location
      @comments = @location.comments.from_pending_to_approved.all
    else
      @comments = Comment.from_pending_to_approved.all
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def approve
    @comment = resource
    @comment.approve!
    respond_to do |format|
      format.js {}
    end
  end
  
end