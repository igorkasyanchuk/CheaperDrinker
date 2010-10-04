class HomeController < ApplicationController
  layout 'public'
  
  def index
    @current_date = DAYS_FOR_SPECIALS.keys[Time.zone.now.to_date.wday]
  end

  def markers
    respond_to do |format|
      format.js do
        @current_day = params['day']
        ne = params['ne'].split(',').collect{|e|e.to_f}
        sw = params['sw'].split(',').collect{|e|e.to_f}
        @locations = Location.in_bounds([sw, ne]).by_name.by_day(@current_day).limit(100)
      end
    end
  end

end
