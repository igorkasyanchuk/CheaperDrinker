Factory.define :special_day, :class => SpecialDay do |f|
  f.association :location
  f.description { Factory.next(:body) }
  f.start_time { [1,2,3].to_a.rand * 60 }
  f.end_time {  (4 + [1,2,3].rand) * 60 }
  f.day_id 0
end