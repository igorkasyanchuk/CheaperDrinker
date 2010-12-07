class EventsController < InheritedResources::Base
  before_filter :store_location, :only => [:show, :index]
  layout 'application'
end
