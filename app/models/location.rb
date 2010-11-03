class Location < ActiveRecord::Base
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TagHelper
  PLANS = {
    0 => :free,
    1 => :premium,
    2 => :premium_plus
  }
  
  DAYS = {
    0 => :monday,
    1 => :tuesday,
    2 => :wednesday,
    3 => :thursday,
    4 => :friday,
    5 => :saturday,
    6 => :sunday
  }
  
  validates_presence_of :name
  #validates_presence_of :description
  validates_presence_of :state
  validates_presence_of :city
  validates_presence_of :address
  validates_presence_of :zip
    
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')
  
  scope :from_pending_to_approved, order('approved ASC')
  
  scope :pending, where(:approved => false)
  scope :approved, where(:approved => true)
  
  scope :except_gay_bars, where(:gay_bar => false)
  
  scope :in_bounds, lambda { |p|
    bounds = Geokit::Bounds.normalize(p)
    sw,ne = bounds.sw, bounds.ne
    lng_sql = bounds.crosses_meridian? ? "(lng<#{ne.lng} OR lng>#{sw.lng})" : "lng>#{sw.lng} AND lng<#{ne.lng}"
    bounds_sql = "lat>#{sw.lat} AND lat<#{ne.lat} AND #{lng_sql}"
    where(bounds_sql)
  }
  scope :by_name, order('name')
  
  scope :by_day, lambda { |day|
    where(Location.day_column(Location.get_day(day)) => true)
  }

  scope :occurs_between, lambda { |*args|
    where(["GREATEST(special_days.start_time, ?) < LEAST(special_days.end_time, ?)", 
    args.shift || 0, args.shift || SpecialDay::END_TIME_OF_DATE]).includes(:special_days) } 

  scope :by_weight_and_random, order("plan desc, #{SqlFunction.random}")
  
  has_many :comments, :dependent => :destroy, :as => :commentable
  has_many :special_days, :dependent => :destroy
  
  accepts_nested_attributes_for :special_days, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:day_id].blank? }
  
  belongs_to :user

  before_save :geocode_it!
  
  def approve!
    self.approved = true
    self.save(:validate => false)
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
    if self.address_changed? || self.new_record? || self.city_changed? || self.zip_changed? || self.state_changed?
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
  
  def location_info(day)
    map_info.merge({ "id" => self.id, 
                     "name" => self.name, 
                     "address" => self.address, 
                     "description" => simple_format(special_for_day(day)),
                     "plan" => self.plan,
                     "gay" => self.gay_bar })
  end
  
  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end
  
  def special?(day)
    self.send(Location.day_column(day))
  end
  
  def short_name_of_special_days
    DAYS_FOR_SPECIALS.keys.collect{|e| DAYS_FOR_SPECIALS[e] if self.special?(e) }.compact
  end
  
  def special_for_day(day)
    load_specials_for_day(day).collect{|s| s.info}.join("\n")
  end
  
  def specials_for_day(day)
    load_specials_for_day(day)
  end
  
  def load_specials_for_day(day)
    self.special_days.by_day(day).by_time
  end  
  
  def free?
    PLANS[self.plan] == :free
  end
  
  def Location.get_day(day)
    day = Location::DAYS.index(day.to_sym) if day.is_a?(String)
    day = Location::DAYS.index(day) if day.is_a?(Symbol)
    day
  end
  
  def Location.day_column(day)
    "day_#{Location.get_day(day)}"
  end

end
