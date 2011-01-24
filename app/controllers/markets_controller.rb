class MarketsController < InheritedResources::Base
  before_filter :store_location
  belongs_to :state
  
  def map
    @market = Market.find(params[:id])
    render :map, :layout => 'public'
  end
  
end
