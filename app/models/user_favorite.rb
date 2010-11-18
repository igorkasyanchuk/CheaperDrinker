class UserFavorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite, :class_name => 'Location', :foreign_key => 'location_id'
  validates_uniqueness_of :location_id, :scope => :user_id
end
