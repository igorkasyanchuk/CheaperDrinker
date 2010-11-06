require 'test_helper'

class SpecialDayTest < ActiveSupport::TestCase
  
  test "test could create with all fields" do
    @special_day = Factory(:special_day)
    assert_not_nil @special_day
  end
  
  test "adding new specials updating Location" do
    @location = Factory(:location)
    assert_false @location.day_0
    assert_false @location.day_1
    special_0_1 = Factory(:special_day, :location => @location)
    special_1_1 = Factory(:special_day, :location => @location, :day_id => 1)
    @location.reload
    assert @location.day_0
    assert @location.day_1
    assert_equal @location.special_days.count, 2
    assert_equal @location.special_days_count, 2
    @location.special_days.destroy_all
    @location.reload
    assert_false @location.day_0
    assert_false @location.day_1
    assert_equal @location.special_days.count, 0
  end
  
  test "load only specific specials" do
    @location_1 = Factory(:location)
    @special_day_0_1 = Factory(:special_day, :location => @location_1, :day_id => 1, :start_time => 0, :end_time => 600)
    @special_day_0_2 = Factory(:special_day, :location => @location_1, :day_id => 1, :start_time => 480, :end_time => 660)
    @special_day_0_3 = Factory(:special_day, :location => @location_1, :day_id => 1, :start_time => 480, :end_time => 720)
    @special_day_0_4 = Factory(:special_day, :location => @location_1, :day_id => 1, :start_time => 540, :end_time => 720)
    @special_day_1_1 = Factory(:special_day, :location => @location_1, :day_id => 2, :start_time => 0, :end_time => 900)
    
    @location_1.reload
    
    assert_equal Location.count, 1
    assert_equal SpecialDay.count, 5
    
    assert_equal @location_1.special_days.count, 5
    assert_equal @location_1.special_days.by_day(1).count, 4
    assert_equal @location_1.special_days.by_day(2).count, 1
    assert_equal @location_1.special_days.by_day(1).occurs_between(0, 540).count, 3
    assert_equal @location_1.special_days.by_day(1).occurs_between(500, 550).count, 4
    assert_equal @location_1.special_days.by_day(1).occurs_between(630, 700).count, 3
    assert_equal @location_1.special_days.by_day(2).occurs_between(1000, 1060).count, 0
  end  

end
