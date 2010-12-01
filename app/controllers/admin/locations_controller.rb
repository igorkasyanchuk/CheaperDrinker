class Admin::LocationsController < Admin::DashboardController

  def index
    scope = Location.from_pending_to_approved
    scope = scope.search_by_name(params[:name]) if params[:name].present?
    scope = scope.search_by_plan(params[:plan]) if params[:plan].present?
    scope = scope.search_by_city(params[:city]) if params[:city].present?
    @total = scope.count
    @locations = scope.paginate :per_page => 30, :page => params[:page]
  end

  def show
    redirect_to admin_path
  end

  def create
    create! do |format|
      format.js {}
    end
  end

  def update
    @location = resource
    if @location.update_attributes(params[:location])
      flash[:notice] = "Location successfully updated."
      redirect_to [:admin, :locations]
    else
      render :edit
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def approve
    @location = resource
    @location.approve!
    respond_to do |format|
      format.js {}
    end
  end

end