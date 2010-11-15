class HomeController < ApplicationController
  layout 'public'
  
  def index
    @current_date = DAYS_FOR_SPECIALS.keys[Time.zone.now.to_date.wday-1]
  end

  def markers
    logger.info(params["from"].green) if params["from"].green
    respond_to do |format|
      format.js do
        @current_day = params['day']
        ne = params['ne'].split(',').collect{|e|e.to_f}
        sw = params['sw'].split(',').collect{|e|e.to_f}
        @location_ids = Location.approved.in_bounds([sw, ne]).by_day(@current_day).limit(200)
        @location_ids = @location_ids.except_gay_bars if params['gay'].present? && params['gay'] == '1'
        @location_ids = @location_ids.occurs_between(params['start'], params['end'])
        @locations = Location.locations_by_ids(@location_ids)
      end
    end
  end
  
  def find_bar
    @location = Geokit::Geocoders::MultiGeocoder.geocode(params['q'])

    if logged_in? && params["default"] == "1" && @location.lat && @location.lng && @location.accuracy
      @user = current_user
      @user.location = params["q"]
      @user.save
    end

    respond_to do |format|
      format.js do
      end
    end
  end

end
