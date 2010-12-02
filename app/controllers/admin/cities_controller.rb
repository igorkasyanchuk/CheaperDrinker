class Admin::CitiesController < Admin::DashboardController
  
  def index
    @cities = City.all :include => :state
    @cities_grouped = @cities.group_by{|c| c.state.name}
  end
  
  def show
    @city = resource
    @city.is_top_city = !@city.is_top_city
    @city.save(:validate => false)
    render :nothing => true
  end
  
end