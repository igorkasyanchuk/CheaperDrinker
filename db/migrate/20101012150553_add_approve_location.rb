class AddApproveLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :approved, :boolean, :default => false
    Location.reset_column_information
    Location.update_all(:approved => true)
  end

  def self.down
    remove_column :locations, :approved
  end
end
