class AddUserLocation < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
    add_column :users, "lat", :decimal, :precision => 15, :scale => 10, :default => 0.0
    add_column :users, "lng", :decimal, :precision => 15, :scale => 10, :default => 0.0      
    add_column :users, :accuracy, :integer, :default => -1
    User.reset_column_information
    User.all.each do |u|
      u.location = 'Minneapolis, Minnesota, MN'
      u.save
    end
  end

  def self.down
    remove_column :users, "location"
    remove_column :users, "lat"
    remove_column :users, "lng"
    remove_column :users, "accuracy"
  end
end