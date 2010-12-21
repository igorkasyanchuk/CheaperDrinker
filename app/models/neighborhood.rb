class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_friendly_id :name_and_city, :use_slug => true, :sequence_separator => ":"
  
  def name_and_city
    "#{self.city.name} #{name}"
  end
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end  
end
