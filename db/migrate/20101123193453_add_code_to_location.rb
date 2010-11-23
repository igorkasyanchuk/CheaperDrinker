class AddCodeToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :activation_code, :string
    Location.reset_column_information
    Location.all.each do |location|
      location.generate_activation_code!
      location.save(:validate => false)
    end
  end

  def self.down
    remove_column :locations, :activation_code
  end
end
