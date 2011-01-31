class City < ActiveRecord::Base
  belongs_to :state
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"
  validates_uniqueness_of :name, :scope => :state_id
  validates_presence_of :name
  
  has_many :locations
  
  scope :by_name, order(:name)
  scope :top, where(:is_top_city => true)
  
  before_create :geocode_me!
  
  def City.autocomplete(name)
    City.where(["LOWER(name) LIKE ?", "#{name.downcase}%"]).limit(15).order(:name).select(:name)
  end
  
  def full_address
    "#{name} #{state.name}"
  end
  
  def geocode_me!
    logger.info "Geocoding: #{self.full_address}"
    _location = Geokit::Geocoders::MultiGeocoder.geocode(self.full_address)
    if _location && _location.lat && _location.lng && _location.accuracy
      self.lat = _location.lat
      self.lng = _location.lng
      self.accuracy = _location.accuracy
    else
      self.accuracy = -1
    end
    true
  end
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end  

end