class User < ActiveRecord::Base
  attr_accessor :require_password
  
  # setup authlogic and use bcrypt to store passwords
  acts_as_authentic do |config|
    config.crypto_provider = Authlogic::CryptoProviders::BCrypt
  end

  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :admin

  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :location
  
  validates_presence_of :password, :if => :require_password?
  validates_presence_of :password_confirmation, :if => :require_password?
  
  has_many :locations, :dependent => :destroy
  has_many :comments, :dependent => :destroy, :as => :commentable
  
  scope :admins, where(:admin => true)
  scope :forward,  order('created_at ASC')
  scope :backward, order('created_at DESC')  
  
  before_save :geocode_it!
  
  def name
    "#{first_name} #{last_name}"
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
