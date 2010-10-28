require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  test "could load correct location for day" do
    assert_equal SpecialDay.count, 0
    assert_equal Location.count, 0
    
    loc = Location.new
    loc.name = 'Cool Bar'
    loc.state = 'MN'
    loc.city = 'Minneapolis'
    loc.address = 'address'
    loc.zip = '55112'
    assert loc.save
    special_monday = loc.specials.build
    special_monday.day_id = 0
    special_monday.description = 'monday day descr'
    special_monday.save
    special_friday = loc.specials.build
    special_friday.day_id = 4
    special_friday.description = 'friday day descr'
    special_friday.save
    
    assert Location.by_day(0).count, 1
    assert Location.by_day(1).count, 0
    assert Location.by_day(2).count, 0
    assert Location.by_day(3).count, 0
    assert Location.by_day(4).count, 1
    assert Location.by_day(5).count, 0
    assert Location.by_day(6).count, 0
    
    assert_equal Location.count, 1
    assert_equal SpecialDay.count, 2
    assert_equal loc.specials.count, 2
    
    #log_to STDOUT
    
    assert_equal loc.specials_for_day(:monday).count, 1
    assert_equal loc.specials_for_day(:friday).count, 1
    
    assert_equal loc.special_for_day(0), 'monday day descr'
    assert_equal loc.special_for_day(4), 'friday day descr'
    
    assert loc.special?(:monday)
    assert !loc.special?(:wednesday)
  end

end
