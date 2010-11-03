Factory.define :location, :class => Location do |f|
  f.name { Factory.next(:name) }
  f.city { Factory.next(:city_name) }
  f.address { Factory.next(:address) }
  f.state { Factory.next(:state_name) }
  f.zip "12345"
  f.plan 0
end