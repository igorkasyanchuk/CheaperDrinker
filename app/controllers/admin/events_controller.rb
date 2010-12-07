class Admin::EventsController < Admin::DashboardController

  def index
    scope = Event.from_pending_to_approved
    scope = scope.search_by_title(params[:title]) if params[:title].present?
    scope = scope.search_by_location(params[:location]) if params[:location].present?
    scope = scope.search_by_location_id(params[:location_id]) if params[:location_id].present?
    @total = scope.count
    @events = scope.paginate :per_page => 30, :page => params[:page]
  end

  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def approve
    @event = resource
    @event.approve!
    respond_to do |format|
      format.js {}
    end
  end

end