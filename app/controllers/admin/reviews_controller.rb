class Admin::ReviewsController < Admin::DashboardController
  belongs_to :location, :optional => true
  
  def index
    index!
    if @location
      @reviews = @location.reviews.from_pending_to_approved.all
    else
      @reviews = Review.from_pending_to_approved.all
    end
  end
  
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