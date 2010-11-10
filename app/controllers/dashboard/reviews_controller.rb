class Dashboard::ReviewsController < Dashboard::DashboardController
  belongs_to :location
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def approve
    @review = resource
    @review.approve!
    respond_to do |format|
      format.js {}
    end
  end
  
end