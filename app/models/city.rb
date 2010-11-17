class City < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true, :sequence_separator => ":"
end