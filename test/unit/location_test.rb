require 'test_helper'
require "ap"

class LocationTest < ActiveSupport::TestCase
  
  test "search Locations by special time" do
    @location = Factory(:location)
    assert_not_nil @location
  end
  
  test "seatch locations by search time" do
    @location = Factory(:location)
    @special_day_0_1 = Factory(:special_day, :start_time => 0, :end_time => 600)
    @special_day_0_2 = Factory(:special_day, :start_time => 0, :end_time => 720)
    @special_day_0_3 = Factory(:special_day, :start_time => 600, :end_time => 720)
    @special_day_0_4 = Factory(:special_day, :start_time => 660, :end_time => 780)
    @special_day_0_5 = Factory(:special_day, :start_time => 900, :end_time => SpecialDay::END_TIME_OF_DATE)
    
    log_to STDOUT
    #assert_equal Location.by_time(0,600).count, 2
    ap Location.timed(0,600)
    ap Location.timed(0,600).count
    ap Location.timed(0,600)[0]
    ap Location.timed(0,600)[1]
    ap Location.timed(0,600)[2]
    
    log_to nil
  end

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
    special_monday = loc.special_days.build
    special_monday.day_id = 0
    special_monday.description = 'monday day descr'
    special_monday.save
    special_friday = loc.special_days.build
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
    assert_equal loc.special_days.count, 2
    
    #log_to STDOUT
    
    assert_equal loc.specials_for_day(:monday).count, 1
    assert_equal loc.specials_for_day(:friday).count, 1
    
    assert_equal loc.specials_for_day(0).first.description, 'monday day descr'
    assert_equal loc.specials_for_day(4).first.description, 'friday day descr'
    
    loc.reload
    
    assert loc.special?(:monday)
    assert !loc.special?(:wednesday)
  end

end
