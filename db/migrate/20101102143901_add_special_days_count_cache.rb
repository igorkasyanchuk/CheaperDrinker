class AddSpecialDaysCountCache < ActiveRecord::Migration
  def self.up
    add_column :locations, :special_days_count, :integer, :default => 0
    Location.reset_column_information
    Location.find(:all).each do |p|
      Location.update_counters p.id, :special_days_count => p.special_days.length
    end
  end

  def self.down
    remove_column :locations, :special_days_count
  end
end
