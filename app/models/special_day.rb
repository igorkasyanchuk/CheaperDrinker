class SpecialDay < ActiveRecord::Base
  belongs_to :location, :counter_cache => true
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :day_id
  validates_presence_of :description
  START_TIME_OF_DAY = 0
  AN_HOUR = 60
  AN_HALF_HOUR = AN_HOUR / 2
  END_TIME_OF_DATE = AN_HOUR * 24
  
  scope :by_day, lambda { |day|
    where(["day_id = ?", Location.get_day(day)])
  }
  scope :by_time, order(:start_time)
  scope :by_location, group("special_days.location_id")
  
  after_save :update_cached_day
  after_destroy :update_cached_day
  
  def update_cached_day
    locations = location.specials_for_day(self.day_id).count
    location.update_attribute(Location.day_column(self.day_id), locations > 0)
  end
  
  def info
    self.time_info + "\n" + self.description
  end
  
  def time_info
    "#{SpecialDay.translate_time(start_time)} - #{SpecialDay.translate_time(end_time)}"
  end
  
  def SpecialDay.translate_time(time)
    TIMES_ARRAY[time / SpecialDay::AN_HALF_HOUR]
  end

end
