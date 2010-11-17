class StatesController < InheritedResources::Base
  before_filter :store_location
  
  def index
    @states = State.by_name.all
  end

end
