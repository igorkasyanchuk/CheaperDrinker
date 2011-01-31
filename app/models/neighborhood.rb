class Neighborhood < ActiveRecord::Base
  belongs_to :market
  has_friendly_id :name_and_market, :use_slug => true
  
  validates_presence_of :name
  
  def name_and_market
    "#{self.market.name} #{name}"
  end
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end  
end
