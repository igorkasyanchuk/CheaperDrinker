class Dashboard::CommentsController < Dashboard::DashboardController
  belongs_to :location
  
  def show
    @comment = resource
    @comment.approve!
    redirect_to [:dashboard, current_user, @location, :comments]
  end
  
  def destroy
    @comment = resource
    @comment.destroy
    redirect_to [:dashboard, current_user, @location, :comments]
  end  
  
end