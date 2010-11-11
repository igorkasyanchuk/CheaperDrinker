class ChangeOverallType < ActiveRecord::Migration
  def self.up
    change_column :reviews, :overall_rating, :float, :default => 0
  end

  def self.down
  end
end
