class AddZoomLevelForNeib < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, :zoom_level, :integer, :default => 13
    Neighborhood.update_all(:zoom_level => 13)
  end

  def self.down
    remove_column :neighborhoods, :zoom_level
  end
end
