class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :user

  has_attached_file :photo, :styles => { :medium => ["600x400>", :png], :thumb => ["60x40>", :png] }
end
