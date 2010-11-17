class MoveToCities < ActiveRecord::Migration
  def self.up
    Location.all.each do |location|
      city = City.find_or_create_by_name_and_state_id(location.city, location.state_id)
      location.city_id = city.id
      location.save(:validate => false)
    end
  end

  def self.down
  end
end
