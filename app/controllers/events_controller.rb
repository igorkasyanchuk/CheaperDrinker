class EventsController < InheritedResources::Base
  before_filter :store_location, :only => [:show, :index]
  layout 'application'
  
  
  def index
    @events = Event.approved.soon.paginate :per_page => 20, :page => params[:page]
  end
  
end
