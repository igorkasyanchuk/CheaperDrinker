class NeighborhoodsController < InheritedResources::Base
  before_filter :store_location
  belongs_to :state
  belongs_to :market
  
  def show
    @neighborhood = Neighborhood.find(params[:id])
    render :show, :layout => 'public'
  end

end