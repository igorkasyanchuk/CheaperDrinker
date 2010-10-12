class Admin::LocationsController < Admin::DashboardController
  
  def index
    @locations = Location.from_pending_to_approved.all
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
      redirect_to [:dashboard, current_user, @location]
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