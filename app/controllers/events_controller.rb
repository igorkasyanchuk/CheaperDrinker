class EventsController < ApplicationController
  before_filter :store_location, :only => [:show, :index]
  layout 'place'
end
