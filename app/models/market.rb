class Market < ActiveRecord::Base

  belongs_to :state
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"
  has_many :cities
  
  validates_presence_of :name
  validates_presence_of :state_id
  
  scope :by_name, order(:name)
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end

end
