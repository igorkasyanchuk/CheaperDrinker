GOOGLE_KEYS = {
  "development" => "ABQIAAAA-fvnmbkR8BJ_xVoxel7PfhSvcDMizmiBvzrB1F5eJeU6gK2K7RQW3Pfw8DmhMhUuewSuQjcD20SoUA",
  "test" => "ABQIAAAA-fvnmbkR8BJ_xVoxel7PfhSvcDMizmiBvzrB1F5eJeU6gK2K7RQW3Pfw8DmhMhUuewSuQjcD20SoUA",
  "production" => "ABQIAAAAeGlGRfeULyAPWr3-syWI4xTUvJdBBoS-HuHv63g54CTdGhrVoxRCjaS0Cha9M4XtxuV_NKHRQ7TNCQ"
}

STATES = [:alabama, :alaska, :arizona, :arkansas,
          :california, :colorado, :connecticut,
          :delaware, :florida, :georgia, :hawaii, :idaho,
          :illinois, :indiana, :iowa, :kansas,
          :kentucky, :louisiana, :maine, :maryland,
          :massachusetts, :michigan, :minnesota, :mississippi,
          :missouri, :montana, :nebraska, :nevada,
          :new_hampshire, :new_jersey, :new_mexico,
          :new_york, :north_carolina, :north_dakota,
          :ohio, :oklahoma, :oregon, :pennsylvania,
          :rhode_island, :south_carolina, :south_dakota,
          :tennessee, :texas, :utah, :vermont, :virginia,
          :washington, :west_virginia, :wisconsin, :wyoming].collect{|e| e.to_s.camelize.titleize }
          
          
AutoHtml.add_filter(:red_cloth) do |text|
  RedCloth.new(text).to_html
end

days_for_specials = ActiveSupport::OrderedHash.new
days_for_specials[:monday] = 'MON'
days_for_specials[:tuesday] = 'TUE'
days_for_specials[:wednesday] = 'WED'
days_for_specials[:thursday] = 'THU'
days_for_specials[:friday] = 'FRI'
days_for_specials[:saturday] = 'SAT'
days_for_specials[:sunday] = 'SUN'

DAYS_FOR_SPECIALS = days_for_specials

TIMES_ARRAY = [ "6:00am", "6:30am", "7:00am", "7:30am", "8:00am", "8:30am", 
  "9:00am", "9:30am", "10:00am", "10:30am", "11:00am", "11:30am", "12 Noon", "12:30pm", "1:00pm", 
  "1:30pm", "2:00pm", "2:30pm", "3:00pm", "3:30pm", "4:00pm", "4:30pm", "5:00pm", "5:30pm", 
  "6:00pm", "6:30pm", "7:00pm", "7:30pm", "8:00pm", "8:30pm", "9:00pm", "9:30pm", "10:00pm",
  "10:30pm", "11:00pm", "11:30pm", '12 Midnight',
  "0:00am", "0:30am", "1:00am", "1:30am", "2:00am", "2:30am", "3:00am", "3:30am", "4:00am",
  "4:30am", "5:00am", "5:30am" ]