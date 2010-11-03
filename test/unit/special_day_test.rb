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

end
