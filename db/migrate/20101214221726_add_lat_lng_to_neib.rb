class AddLatLngToNeib < ActiveRecord::Migration
  def self.up
    add_column :neighborhoods, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :neighborhoods, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :neighborhoods, :accuracy, :integer, :default => -1     
  end

  def self.down
    remove_column :neighborhoods, "lat"
    remove_column :neighborhoods, "lng"
    remove_column :neighborhoods, "accuracy"
  end
end
