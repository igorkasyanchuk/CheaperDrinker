class City < ActiveRecord::Base
  belongs_to :state
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"
  validates_uniqueness_of :name, :scope => :state_id
  validates_presence_of :name
  
  has_many :locations
  scope :by_name, order(:name)
  
  scope :top, where(:is_top_city => true)
  
  def City.autocomplete(name)
    City.where(["LOWER(name) LIKE ?", "#{name.downcase}%"]).limit(15).order(:name).select(:name)
  end
  
end