class ReviewsController < InheritedResources::Base
  belongs_to :location
  
  def create
    params[:review][:user_id] = current_user.id
    if request.xhr?
      create! do |format|
        format.js {}
      end
    else
      render :text => 'need to be human'
    end
  end

end