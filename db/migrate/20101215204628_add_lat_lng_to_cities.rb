class AddLatLngToCities < ActiveRecord::Migration
  def self.up
    add_column :cities, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :cities, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :cities, :accuracy, :integer, :default => -1
    City.reset_column_information
    City.all.each do |city|
      city.geocode_me!
      city.save(:validate => false)
    end
  end

  def self.down
    remove_column :cities, "lat"
    remove_column :cities, "lng"
    remove_column :cities, "accuracy"
  end
end