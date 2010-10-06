class CommentsController < InheritedResources::Base
  belongs_to :location
  
  def create
    if request.xhr?
      create! do |format|
        format.js {}
      end
    else
      render :text => 'need to be human'
    end
  end

end