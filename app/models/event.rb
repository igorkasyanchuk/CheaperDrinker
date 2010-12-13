class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :user
  belongs_to :event_category
  
  has_friendly_id :title, :use_slug => true, :sequence_separator => "--"

  scope :not_approved, where(:approved => false)
  scope :approved, where(:approved => true)
  scope :recent, order('created_at DESC')
  scope :from_pending_to_approved, order('approved ASC')
  
  scope :from_now, lambda { where(:start.gt => Time.zone.now).order('events.start desc') }
  
  scope :search_by_title, lambda { |title| where(:title.matches => "#{title}%") }  
  scope :search_by_location, lambda { |location| where(:location => {:name.matches => "#{location}%"}).joins(:location) }
  scope :search_by_location_id, lambda { |location_id| where(:location_id => location_id) }  
  
  has_attached_file :photo, :styles => { :medium => ["600x400>", :png], :thumb => ["60x40>", :png], :small => ["320x240>", :png] }
  
  validates_presence_of :title
  validates_presence_of :start
  
  def instantiate_time_object(name, values)
    if values.length == 2
      values = [ self.start.year, self.start.month, self.start.day ] + values
    end
    super(name, values)
  end

  def approve!
    self.approved = true
    self.save
  end
  
  def status
    self.approved ? "accepted" : "pending"
  end
  
  def location_name
    self.location.try(:name)
  end
  
  def category_name
    self.event_category.try(:name)
  end
  
  def has_photo?
    self.photo && self.photo.exists?
  end
  
  def in_location?
    self.location.present?
  end
  
  def has_owner?
    self.user && self.user.present?
  end
  
  def has_time?
    self.start_time.present?
  end
  
  def time
    self.start_time.to_s(:time_12)
  end

end