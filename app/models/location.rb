class Location < ActiveRecord::Base
  
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :state
  validates_presence_of :city
  validates_presence_of :address
  
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')  
  scope :in_bounds, lambda { |p|
    bounds = Geokit::Bounds.normalize(p)
    sw,ne = bounds.sw, bounds.ne
    lng_sql = bounds.crosses_meridian? ? "(lng<#{ne.lng} OR lng>#{sw.lng})" : "lng>#{sw.lng} AND lng<#{ne.lng}"
    bounds_sql = "lat>#{sw.lat} AND lat<#{ne.lat} AND #{lng_sql}"
    where(bounds_sql)
  }
  scope :by_name, order('name')
  
  scope :by_day, lambda { |day|
    where("specials_#{day.downcase} IS NOT NULL AND specials_#{day.downcase} <> ''")
  }

  before_save :geocode_it!
  
  after_initialize :set_state
  
  def set_state
    if new_record?
      self.state = 'Minnesota'
    end
  end
  
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
  
  def special?(day)
    return case day
      when :monday then self.specials_monday.present?
      when :tuesday then self.specials_tuesday.present?
      when :wednesday then self.specials_wednesday.present?
      when :thursday then self.specials_thursday.present?
      when :friday then self.specials_friday.present?
      when :saturday then self.specials_saturday.present?
      when :sunday then self.specials_sunday.present?
      else false;
    end
  end
  
  def special_days
    DAYS_FOR_SPECIALS.keys.collect{|e| DAYS_FOR_SPECIALS[e] if self.special?(e) }.compact
  end
  
end
