class CreateSpecialDays < ActiveRecord::Migration
  def self.up
    create_table :special_days do |t|
      t.integer :location_id
      t.integer :day_id
      t.integer :start_time, :default => SpecialDay::START_TIME_OF_DAY
      t.integer :end_time, :default => SpecialDay::END_TIME_OF_DATE
      t.text :description
      t.timestamps
    end
    add_index :special_days, :location_id
    add_index :special_days, [:location_id, :day_id]
    Location.all.each do |location|
      Location::DAYS.values.each do |day|
        if location.special?(day)
          special_day = location.specials.build
          special_day.description = location.old_day(day)
          special_day.day_id = Location::DAYS.index(day)
          special_day.save
        end
      end
    end
    %w(specials_monday specials_tuesday specials_wednesday specials_thursday specials_friday specials_saturday specials_sunday).each do |c|
      remove_column :locations, c
    end
  end

  def self.down
    remove_index :special_days, :location_id
    remove_index :special_days, [:location_id, :day_id]
    drop_table :special_days
    %w(specials_monday specials_tuesday specials_wednesday specials_thursday specials_friday specials_saturday specials_sunday).each do |c|
      add_column :locations, c, :text
    end
  end
end
