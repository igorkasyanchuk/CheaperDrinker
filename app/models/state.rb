class State < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :cities
  
  scope :by_name, order(:name)
end