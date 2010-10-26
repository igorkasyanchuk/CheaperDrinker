class AddGayBarOption < ActiveRecord::Migration
  def self.up
    add_column :locations, :gay_bar, :boolean, :default => false
    Location.reset_column_information
    Location.update_all(:gay_bar => false)
  end

  def self.down
    remove_column :locations, :gay_bar
  end
end
