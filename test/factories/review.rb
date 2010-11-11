Factory.define :review_object, :class => Review do |f|
  f.review "review"
  f.service_rating 5
  f.overall_rating 4
  f.atmosphere_rating 3
  f.value_rating 4
  f.approved true
  f.association :user
  f.association :reviewable, :factory => :location
end