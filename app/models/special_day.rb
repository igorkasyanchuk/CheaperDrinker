class SpecialDay < ActiveRecord::Base
  belongs_to :location, :counter_cache => true
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :day_id
  validates_presence_of :description
  START_TIME_OF_DAY = 0
  AN_HOUR = 60
  END_TIME_OF_DATE = AN_HOUR * 24
  
  scope :by_day, lambda { |day|
    where(["day_id = ?", Location.get_day(day)])
  }
  
  after_save :update_cached_day
  after_destroy :update_cached_day
  
  def update_cached_day
    locations = location.specials_for_day(self.day_id).count
    location.update_attribute(Location.day_column(self.day_id), locations > 0)
  end

end
