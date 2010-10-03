class AddSpecials < ActiveRecord::Migration
  def self.up
    ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |c|
      add_column :locations, "specials_#{c}", :text, :default => nil
    end
    add_column :locations, :phone, :string
    add_column :locations, :web_site, :string
    add_column :locations, :contact_email, :string
    add_column :locations, :twitter, :string
  end

  def self.down
    ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |c|
      remove_column :locations, "specials_#{c}"
    end
    remove_column :locations, :phone
    remove_column :locations, :web_site
    remove_column :locations, :contact_email
    remove_column :locations, :twitter
  end
end
