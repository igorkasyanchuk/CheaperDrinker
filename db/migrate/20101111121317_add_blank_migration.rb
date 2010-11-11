class AddBlankMigration < ActiveRecord::Migration
  def self.up
    Location.reset_column_information
    Location.all.each do |loc|
      loc.average_rating = loc.reviews.approved.average(:overall_rating).to_f
      loc.save
    end    
  end

  def self.down
  end
end
