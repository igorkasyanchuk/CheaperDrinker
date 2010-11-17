class PlacesController < ApplicationController
  before_filter :store_location
  layout 'place'

  def index
    redirect_to root_path
  end

  def show
    @location = Location.find(params[:id])
    @review = @location.reviews.build
  end
  
  def reviews
    @location = Location.find(params[:id])
    @review = @location.reviews.build
  end

end
