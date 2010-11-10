class PlacesController < ApplicationController

  def index
    redirect_to root_path
  end

  def show
    @location = Location.find(params[:id])
    @review = @location.reviews.build
  end

end
