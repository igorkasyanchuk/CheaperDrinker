class Market < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"

  belongs_to :state
  has_many :cities
  has_many :neighborhoods
  
  validates_presence_of :name
  validates_presence_of :state_id
  
  scope :by_name, order(:name)
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng, "zoom" => 13 }
  end

end
