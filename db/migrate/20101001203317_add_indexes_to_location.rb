class AddIndexesToLocation < ActiveRecord::Migration
  def self.up
    add_index  :locations, [:lat, :lng]
  end

  def self.down
    remove_index  :locations, [:lat, :lng]
  end
end
