class MakeCodeUpperCase < ActiveRecord::Migration
  def self.up
    Location.all.each do |loc|
      loc.activation_code = loc.activation_code.upcase
      loc.save(:validate => false)
    end
  end

  def self.down
  end
end
