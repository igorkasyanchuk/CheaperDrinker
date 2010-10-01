class HomeController < ApplicationController
  layout 'public'
  
  def index
  end

  def markers
    respond_to do |format|
      format.js do
        ne = params['ne'].split(',').collect{|e|e.to_f}
        sw = params['sw'].split(',').collect{|e|e.to_f}
        @locations = Location.in_bounds([sw, ne]).by_name.limit(100)
      end
    end
  end

end
