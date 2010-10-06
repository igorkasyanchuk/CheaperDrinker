class PlacesController < ApplicationController

  def index
    redirect_to root_path
  end

  def show
    @location = Location.find(params[:id])
    @comment = @location.comments.build
  end

end
