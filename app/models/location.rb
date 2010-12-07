class Location < ActiveRecord::Base
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include ActionView::Helpers::TagHelper
  
  acts_as_mappable
  
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
  
  has_friendly_id :name_and_city, :use_slug => true, :sequence_separator => ":"
  
  define_index do
    indexes :name, :sortable => true
    indexes :city
    indexes :state
    indexes :address
    indexes :zip

    set_property :delta => true
  end
  
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

  scope :search_by_name, lambda { |name| where(:name.matches => "#{name}%") }
  scope :search_by_plan, lambda { |plan| where(:plan=> plan) }
  scope :search_by_city, lambda { |city| where(:city => city) }  

  scope :by_day, lambda { |day|
    where(["special_days.day_id = ?", Location.get_day(day)])
  }

  scope :occurs_between, lambda { |*args|
    where(["GREATEST(special_days.start_time, ?) < LEAST(special_days.end_time, ?)", 
    args.shift || 0, args.shift || SpecialDay::END_TIME_OF_DATE]).joins(:special_days).group("locations.id").select("locations.id") }

  scope :by_weight_and_random, order("plan DESC, #{SqlFunction.random}")
  
  scope :by_plan, order("plan desc")
  scope :by_random, order(SqlFunction.random)
  
  has_many :special_days, :dependent => :destroy
  accepts_nested_attributes_for :special_days, :allow_destroy => true, :reject_if => proc { |attrs| attrs[:day_id].blank? }
  
  has_many :events
  
  belongs_to :user
  belongs_to :bar_network

  before_save :check_state_city!
  before_save :geocode_it!
  before_save :check_fields!
  before_create :generate_activation_code!
  
  has_many :reviews, :as => :reviewable, :dependent => :destroy
  has_one :location_schedule
  accepts_nested_attributes_for :location_schedule
  
  belongs_to :parent_city, :class_name => "City", :foreign_key => "city_id"
  
  has_attached_file :logo, :styles => { :medium => ["280x119>", :png], :thumb => ["94x40>", :png] }

  def Location.locations_by_ids(ids)
    Location.where(:id => ids).by_plan
  end
  
  def name_and_city
    "#{name} #{city}"
  end
  
  def generate_activation_code!
    chars = ['A'..'Z', '0'..'9'].map{|r|r.to_a}.flatten
    self.activation_code = Array.new(8).map{chars[rand(chars.size)]}.join
  end
  
  def check_fields!
    self.phone.gsub!(/\D/, '') unless self.phone.blank?
  end

  def approve!
    self.approved = true
    self.save(:validate => false)
  end
  
  def status
    approved ? "approved" : "pending"
  end
  
  def full_address
    _address = ''
    _address += self.address + ', ' unless self.address.blank?
    _address += self.city + ', ' unless self.city.blank?
    _address += self.state + ', ' unless self.state.blank?
    _address += self.zip unless self.zip.blank?
    _address
  end
  
  def check_state_city!
    _state = State.find_or_create_by_name(self.state)
    self.state_id = _state.id
    _city = City.find_or_create_by_name_and_state_id(self.city, self.state_id)
    self.city_id = _city.id
  end

  def geocode_it!
    if self.address_changed? || self.new_record? || self.city_changed? || self.zip_changed? || self.state_changed?
      logger.info "Geocoding: #{self.full_address}"
      _location = Geokit::Geocoders::MultiGeocoder.geocode(self.full_address)
      if _location && _location.lat && _location.lng && _location.accuracy
        self.lat = _location.lat
        self.lng = _location.lng
        self.accuracy = _location.accuracy
      else
        self.accuracy = -1
      end
    end
    true
  end
  
  def has_logo?
    self.logo && self.logo.exists?
  end
  
  def from_user?
    self.user && self.user.present?
  end
  
  def location_info(day, _start = 0, _end = SpecialDay::END_TIME_OF_DATE)
    map_info.merge({ "id" => self.cached_slug, 
                     "name" => self.name, 
                     "address" => self.address, 
                     "description" => simple_format(special_for_day(day, _start, _end)),
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
  
  def special_for_day(day, _start = 0, _end = SpecialDay::END_TIME_OF_DATE)
    load_specials_for_day(day, _start, _end).collect{|s| s.info}.join("\n\n")
  end
  
  def specials_for_day(day, _start = 0, _end = SpecialDay::END_TIME_OF_DATE)
    load_specials_for_day(day)
  end
  
  def load_specials_for_day(day, _start = 0, _end = SpecialDay::END_TIME_OF_DATE)
    self.special_days.by_day(day).occurs_between(_start, _end).by_time
  end  
  
  def free?
     plan_name == :free
  end
  
  def plan_name
    PLANS[self.plan]
  end
  
  def Location.get_day(day)
    day = Location::DAYS.index(day.to_sym) if day.is_a?(String)
    day = Location::DAYS.index(day) if day.is_a?(Symbol)
    day
  end
  
  def Location.day_column(day)
    "day_#{Location.get_day(day)}"
  end
  
  def self.autocomplete(term, limit, order)
    term ||= ''
    term.gsub(".", ' ')
    term.gsub(",", ' ')
    Location.search "#{term}*", :limit => limit, :order => order, :field_weights => {
      :name => 10,
      :city => 6,
      :state => 3
    }
  end
  
  def schedule_present?
    self.location_schedule.present? && self.location_schedule.has_shedule?
  end
  
  def title
    "#{self.name} #{self.city}"
  end
  
  def any_icon?
    self.gay_bar
  end

end
