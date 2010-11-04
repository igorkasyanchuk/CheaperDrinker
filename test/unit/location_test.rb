require 'test_helper'
require "ap"

class LocationTest < ActiveSupport::TestCase
  
  test "search works fast" do
    @location_1 = Factory(:location)
    @location_2 = Factory(:location)
    @special_day_0_1 = Factory(:special_day, :location => @location_1, :day_id => 1)
    @special_day_0_2 = Factory(:special_day, :location => @location_1, :day_id => 1)
    @special_day_0_3 = Factory(:special_day, :location => @location_2, :day_id => 1)
    assert_equal Location.count, 2
    assert_equal SpecialDay.count, 3
    log_to STDOUT
    array = Location.approved.by_weight_and_random.by_day(1).except_gay_bars.occurs_between(0,SpecialDay::END_TIME_OF_DATE)
    assert_equal array.size, 2
  end
  
  # test "search Locations by special time" do
  #   @location = Factory(:location)
  #   assert_not_nil @location
  # end
  # 
  # test "seatch locations by search time" do
  #   @location = Factory(:location)
  #   @special_day_0_1 = Factory(:special_day, :start_time => 0, :end_time => 600)
  #   @special_day_0_2 = Factory(:special_day, :start_time => 0, :end_time => 720)
  #   @special_day_0_3 = Factory(:special_day, :start_time => 400, :end_time => 500)
  #   @special_day_0_4 = Factory(:special_day, :start_time => 600, :end_time => 720)
  #   @special_day_0_5 = Factory(:special_day, :start_time => 660, :end_time => 780)
  #   @special_day_0_6 = Factory(:special_day, :start_time => 900, :end_time => 1020)
  #   @special_day_0_7 = Factory(:special_day, :start_time => 1080, :end_time => SpecialDay::END_TIME_OF_DATE)
  #   assert_equal Location.occurs_between(0,600).count, 3
  #   assert_equal Location.occurs_between(920,980).count, 1
  #   assert_equal Location.occurs_between(0,SpecialDay::END_TIME_OF_DATE).count, 7
  # end
  # 
  # test "could load correct location for day" do
  #   assert_equal SpecialDay.count, 0
  #   assert_equal Location.count, 0
  #   
  #   loc = Location.new
  #   loc.name = 'Cool Bar'
  #   loc.state = 'MN'
  #   loc.city = 'Minneapolis'
  #   loc.address = 'address'
  #   loc.zip = '55112'
  #   assert loc.save
  #   special_monday = loc.special_days.build
  #   special_monday.day_id = 0
  #   special_monday.description = 'monday day descr'
  #   special_monday.save
  #   special_friday = loc.special_days.build
  #   special_friday.day_id = 4
  #   special_friday.description = 'friday day descr'
  #   special_friday.save
  #   
  #   assert Location.by_day(0).count, 1
  #   assert Location.by_day(1).count, 0
  #   assert Location.by_day(2).count, 0
  #   assert Location.by_day(3).count, 0
  #   assert Location.by_day(4).count, 1
  #   assert Location.by_day(5).count, 0
  #   assert Location.by_day(6).count, 0
  #   
  #   assert_equal Location.count, 1
  #   assert_equal SpecialDay.count, 2
  #   assert_equal loc.special_days.count, 2
  #   
  #   #log_to STDOUT
  #   
  #   assert_equal loc.specials_for_day(:monday).count, 1
  #   assert_equal loc.specials_for_day(:friday).count, 1
  #   
  #   assert_equal loc.specials_for_day(0).first.description, 'monday day descr'
  #   assert_equal loc.specials_for_day(4).first.description, 'friday day descr'
  #   
  #   loc.reload
  #   
  #   assert loc.special?(:monday)
  #   assert !loc.special?(:wednesday)
  # end

end
