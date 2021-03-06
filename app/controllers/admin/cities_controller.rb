class Admin::CitiesController < Admin::DashboardController
  
  def index
    @cities = City.all :include => [:state]
    @cities_grouped = @cities.group_by{|c| c.state.name}
  end
  
  def toggle
    @city = resource
    @city.is_top_city = !@city.is_top_city
    @city.save(:validate => false)
    render :nothing => true
  end
  
  def set_market
    @city = resource
    @city.market_id = params["market_id"]
    @city.save(:validate => false)
    render :nothing => true
  end
  
end