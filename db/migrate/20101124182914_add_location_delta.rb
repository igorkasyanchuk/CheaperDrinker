class AddLocationDelta < ActiveRecord::Migration
  def self.up
    add_column :locations, :delta, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :locations, :delta
  end
end
