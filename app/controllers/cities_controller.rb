class CitiesController < InheritedResources::Base
  before_filter :store_location
  belongs_to :state
  
  def map
    @city = City.find(params[:id])
    render :map, :layout => 'public'
  end
  
end
