class Dashboard::LocationsController < Dashboard::DashboardController
  belongs_to :user
  
  def index
    redirect_to dashboard_path
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

end