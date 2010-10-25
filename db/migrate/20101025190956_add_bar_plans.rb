class AddBarPlans < ActiveRecord::Migration
  def self.up
    add_column :locations, :plan, :integer, :default => 0
    Location.reset_column_information
    Location.update_all('plan = 0')
  end

  def self.down
    remove_column :locations, :plan
  end
end
