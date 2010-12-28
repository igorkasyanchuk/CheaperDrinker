class Admin::PostsController < Admin::DashboardController

  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def approve
    @post = resource
    @post.approve!
    respond_to do |format|
      format.js {}
    end
  end

end