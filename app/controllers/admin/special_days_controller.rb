class Admin::SpecialDaysController < Admin::DashboardController
  belongs_to :location
  
  def index
    index! { @special_day = @location.special_days.build }
  end
  
  def create
    @location = Location.find(params['location_id'])
    days = params["special_days"] || []
    @result = false
    days.each do |day|
      special = @location.special_days.build(params["special_day"])
      special.day_id = day
      @result |= special.save
    end
    create! do |format|
      format.js {}
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def update
    @special_day = resource
    @result = @special_day.update_attributes(params['special_day'])
    respond_to do |format|
      format.js {}
    end
  end

end