require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  test "could create Review" do
    @location = Factory(:location)
    @review = Review.new({:approved => true, :reviewable => @location, :review => 'review 1', :service_rating => 5, :atmosphere_rating => 4, :value_rating => 3})
    assert @review.save
    assert_equal @review.overall_rating, 4.0
    
    @location.reload
    assert_equal @location.average_rating, 4.0

    @review2 = Review.new({:approved => true, :reviewable => @location, :review => 'review 2', :service_rating => 3, :atmosphere_rating => 3, :value_rating => 3})
    assert @review2.save
    assert_equal @review2.overall_rating, 3.0
    
    @location.reload
    assert_equal @location.average_rating, 3.5
    
    @location.reviews.last.destroy
    @location.reload
    assert_equal @location.average_rating, 4.0
  end
  
end
