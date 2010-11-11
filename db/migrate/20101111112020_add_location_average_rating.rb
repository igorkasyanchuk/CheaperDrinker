class AddLocationAverageRating < ActiveRecord::Migration
  def self.up
    add_column :locations, :average_rating, :float, :default => 0
  end

  def self.down
    remove_column :locations, :average_rating
  end
end
