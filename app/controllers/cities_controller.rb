class CitiesController < InheritedResources::Base
  before_filter :store_location
  belongs_to :state
end
