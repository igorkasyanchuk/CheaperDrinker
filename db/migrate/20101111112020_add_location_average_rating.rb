class AddLocationAverageRating < ActiveRecord::Migration
  def self.up
    add_column :locations, :average_rating, :float, :default => 0
    Location.reset_column_information
    Location.all.each do |loc|
      loc.average_rating = loc.reviews_average_rating
      loc.save
    end
  end

  def self.down
    remove_column :locations, :average_rating
  end
end
