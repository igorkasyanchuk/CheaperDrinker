class AddSynopsis < ActiveRecord::Migration
  def self.up
    add_column :locations, :synopsis, :text
    Location.all.each do |l|
      l.create_location_schedule unless l.location_schedule
    end
  end

  def self.down
    remove_column :locations, :synopsis
  end
end
