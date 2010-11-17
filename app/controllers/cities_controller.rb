class CitiesController < ApplicationController
  before_filter :store_location

  def index
    @cities = City.all
  end

end
