class Location < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :state
  validates_presence_of :city
  validates_presence_of :address
  
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')  

  before_save :geocode_it!
  
  def full_address
    _address = ''
    _address += self.address + ', ' unless self.address.blank?
    _address += self.city + ', ' unless self.city.blank?
    _address += self.state + ', ' unless self.state.blank?
    _address += self.zip unless self.zip.blank?
    _address
  end
  
  def geocode_it!
    if self.address_changed? || self.new_record?
      logger.info "Geocoding: #{self.full_address}"
      _location = Geokit::Geocoders::MultiGeocoder.geocode(self.full_address)
      if _location.lat && _location.lng && _location.accuracy
        self.lat = _location.lat
        self.lng = _location.lng
        self.accuracy = _location.accuracy
      else
        self.accuracy = -1
      end
    end
    true
  end
  
  def location_info
    { "lat" => self.lat, "lng" => self.lng, "id" => self.id, "name" => self.name, "description" => RedCloth.new(self.description).to_html }
  end  
  
end
