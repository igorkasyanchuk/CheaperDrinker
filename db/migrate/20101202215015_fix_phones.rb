class FixPhones < ActiveRecord::Migration
  def self.up
    Location.all.each do |location|
      next if location.phone.blank?
      phone = location.phone.gsub(/\D/, '')
      location.phone = phone
      location.save(:validate => false)
      puts "Converted: #{phone}"
    end
  end

  def self.down
  end
end
