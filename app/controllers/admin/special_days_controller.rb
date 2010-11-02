class Admin::SpecialDaysController < Admin::DashboardController
  belongs_to :location
  
  def index
    index! { @special_day = @location.special_days.build }
  end
  
  def create
    create! do |format|
      format.js {}
    end
  end
  
  def destroy
    destroy! do |format|
      format.js {}
    end
  end
  
  def update
    respond_to do |format|
      format.js {}
    end
  end

end