class AddCachedFlags < ActiveRecord::Migration
  def self.up
    (0...7).each do |d|
      add_column :locations, "day_#{d}", :boolean, :default => false
    end
    Location.reset_column_information
    Location.all.each do |l|
      Location::DAYS.keys.each do |day|
        l.send(Location.day_column(day), l.load_specials_for_day(day).count > 0)
      end
      l.save(:validate => false)
    end
  end

  def self.down
    (0...7).each do |d|
      remove_column :locations, "day_#{d}"
    end
  end
end
