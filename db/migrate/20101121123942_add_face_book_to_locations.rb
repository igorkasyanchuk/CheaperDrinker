class AddFaceBookToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :facebook, :string
  end

  def self.down
    remove_column :locations, :facebook
  end
end
