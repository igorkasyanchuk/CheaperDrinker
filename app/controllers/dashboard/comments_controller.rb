class Dashboard::CommentsController < Dashboard::DashboardController
  belongs_to :location
  
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