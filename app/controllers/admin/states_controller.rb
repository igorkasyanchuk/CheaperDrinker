class Admin::StatesController < Admin::DashboardController
  
  def index
    @states = State.by_name.all
  end
  
end