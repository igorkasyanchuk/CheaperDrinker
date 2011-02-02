class HomeController < ApplicationController
  layout 'public'
  
  def index
    @current_date = DAYS_FOR_SPECIALS.keys[Time.zone.now.to_date.wday-1]
    @posts = Post.approved.backward.limit(8)
  end

  def markers
    logger.info(params["from"].green) if params["from"].green
    respond_to do |format|
      format.js do
        @current_day = params['day']
        ne = params['ne'].split(',').collect{|e|e.to_f}
        sw = params['sw'].split(',').collect{|e|e.to_f}
        @location_ids = Location.approved.in_bounds([sw, ne]).by_day(@current_day).limit(250)
        @location_ids = @location_ids.except_gay_bars if params['gay'].present? && params['gay'] == '1'
        @location_ids = @location_ids.occurs_between(params['start'], params['end'])
        @location_ids = @location_ids.by_random
        @locations = Location.locations_by_ids(@location_ids)
      end
    end
  end
  
  def verify
    render :verify, :layout => 'application'
  end
  
  def check_verify
    @location = Location.find_by_activation_code_and_is_code_used(params[:code], false)
    redirect_to new_user_path(:code => params[:code]) and return if @location
    render :check_verify, :layout => 'application'
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
  
  def autocomplete_location_name
    @locations = Location.autocomplete(params['term'], 15, :name)
    render :json => @locations.collect{|location| {:name => location.name, :href => place_path(location), :address => "#{location.city}, #{location.state}"}}.to_json
  end
  
  def autocomplete_city_name
    @cities = City.autocomplete(params['term'])
    render :json => @cities.collect{|city| city.name}.to_json
  end
  
  def search
    query = params[:q]
    @locations = Location.search "#{query}*", :page => params[:page], :per_page => 24
  end

end
