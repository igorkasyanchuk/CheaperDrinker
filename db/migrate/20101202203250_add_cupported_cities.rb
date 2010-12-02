class AddCupportedCities < ActiveRecord::Migration
  def self.up
    add_column :cities, :is_top_city, :boolean, :default => false
    City.reset_column_information
    City.update_all(:is_top_city => false)
  end

  def self.down
    remove_column :cities, :is_top_city
  end
end
