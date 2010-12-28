class User < ActiveRecord::Base
  attr_accessor :require_password, :code
  
  # setup authlogic and use bcrypt to store passwords
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :admin, :location, :code, :facebook, :twitter

  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :location
  
  validates_presence_of :password, :if => :require_password?
  validates_presence_of :password_confirmation, :if => :require_password?
  
  has_many :locations, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :events
  
  has_many :user_favorites, :dependent => :destroy
  has_many :favorites, :through => :user_favorites
  has_many :posts
  
  scope :admins, where(:admin => true)
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')  
  
  before_save :geocode_it!
  after_create :map_to_location_if_code!
  
  def map_to_location_if_code!
    unless self.code.blank?
      @location = Location.find_by_activation_code_and_is_code_used(self.code, false)
      @location.user_id = self.id
      @location.is_code_used = true
      @location.save(:validate => false)
    end
  end
  
  def name
    "#{first_name} #{last_name}"
  end
  
  def short_information
    "#{name} - #{email}"
  end
  
  def require_password?
    new_record? || require_password
  end
  
  def is_admin?
    admin
  end
  
  def toggle_admin!
    self.admin = !is_admin?
    self.save
  end
  
  def geocode_it!
    if self.location_changed? || self.new_record?
      logger.info "Geocoding: #{self.location}"
      _location = Geokit::Geocoders::MultiGeocoder.geocode(self.location)
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

  def map_info
    { "lat" => self.lat, "lng" => self.lng }
  end

end
