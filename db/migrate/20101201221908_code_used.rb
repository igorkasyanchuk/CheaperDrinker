class CodeUsed < ActiveRecord::Migration
  def self.up
    add_column :locations, :is_code_used, :boolean, :default => true
    Location.reset_column_information
    Location.update_all(:is_code_used => false)
  end

  def self.down
    remove_column :locations, :is_code_used
  end
end
