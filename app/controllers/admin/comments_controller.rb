class Admin::CommentsController < Admin::DashboardController
  
  def index
    @comments = Comment.from_pending_to_approved.all
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