GOOGLE_KEYS = {
  "development" => "ABQIAAAA-fvnmbkR8BJ_xVoxel7PfhSvcDMizmiBvzrB1F5eJeU6gK2K7RQW3Pfw8DmhMhUuewSuQjcD20SoUA",
  "test" => "ABQIAAAA-fvnmbkR8BJ_xVoxel7PfhSvcDMizmiBvzrB1F5eJeU6gK2K7RQW3Pfw8DmhMhUuewSuQjcD20SoUA",
  "production" => "ABQIAAAAeGlGRfeULyAPWr3-syWI4xQihcliIwC4o2ci4ydC631Hy3HctxQdN9QjqsAQFk-u6iCqunZDqPywPA"
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
