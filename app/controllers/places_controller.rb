class PlacesController < ApplicationController
  before_filter :store_location, :only => [:show, :reviews]

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
  
  def add_to_favorites
    @location = Location.find(params[:id])
    respond_to do |page|
      page.js {}
    end
  end
  
  def remove_from_favorites
    @location = Location.find(params[:id])
    respond_to do |page|
      page.js {}
    end
  end  

end
