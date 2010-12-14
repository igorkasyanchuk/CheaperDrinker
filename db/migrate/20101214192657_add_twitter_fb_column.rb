class AddTwitterFbColumn < ActiveRecord::Migration
  def self.up
    change_column :locations, :twitter, :string, :default => "twitter.com/"
    change_column :locations, :facebook, :string, :default => "facebook.com/"
    Location.reset_column_information
    Location.all.each do |loc|
      loc.twitter = "twitter.com/" if loc.twitter.blank?
      loc.facebook = "facebook.com/" if loc.facebook.blank?
      loc.save(:validate => false)
    end
  end

  def self.down
  end
end
