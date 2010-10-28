class SpecialDay < ActiveRecord::Base
  belongs_to :location
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :day_id
  validates_presence_of :description
  START_TIME_OF_DAY = 0
  END_TIME_OF_DATE = 1440
  
  scope :by_day, lambda { |day|
    day = Location::DAYS.index(day.to_sym) if day.is_a?(String)
    day = Location::DAYS.index(day) if day.is_a?(Symbol)
    where(["day_id = ? AND description IS NOT NULL AND description <> ?", day, ''])
  }
end
