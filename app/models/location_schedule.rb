class LocationSchedule < ActiveRecord::Base
  FIELDS = [:starts_monday_at, :ends_monday_at, :starts_tuesday_at, :ends_tuesday_at, :starts_wednesday_at, :ends_wednesday_at,
      :starts_thursday_at, :ends_thursday_at, :starts_friday_at, :ends_friday_at, :starts_saturday_at, :ends_saturday_at, :starts_sunday_at, :ends_sunday_at]

  belongs_to :location
  
  def has_shedule?
    FIELDS.any?{|f| self.send(f) > 0}
  end
  
end