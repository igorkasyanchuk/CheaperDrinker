module ApplicationHelper
  include Rack::Recaptcha::Helpers
  
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << "<div class='#{msg} flash'>#{html_escape(flash[msg.to_sym])}</div>" unless flash[msg.to_sym].blank?
    end
    flash.clear
    messages
  end
  
  def inside_layout(layout = 'application', &block) 
    render :inline => capture_haml(&block), :layout => "layouts/#{layout}" 
  end
  
  def yield_or_default(message, default_message = "")
    message.nil? ? default_message : message
  end
  
  def title(t)
    content_for :title do
      t
    end
  end   
  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, :class => css_class
  end
  
  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end  

  def add_google_map
    content_for :map do
      '<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>'
    end
  end
  
  def yes_no(b)
    b ? 'yes' : b.nil? ? '' : 'no'
  end
  
  def dashboard?
    controller_name == 'dashboard' && action_name = 'welcome'
  end
  
  def home_page?
    controller_name == 'home' && action_name = 'index'
  end
  
  def include_google_analytics
    render :partial => '/shared/ga' if Rails.env == 'production'
  end
  
  def add_admin_nav
    content_for :admin_nav_items do
      (link_to 'Admin Panel', admin_path)
    end if current_user && current_user.is_admin?
  end
  
  def gay_icon(location, type=:small)
    if location.gay_bar
      if type == :small
        image_tag 'bar/gay_small.png', :title => 'gay bar'
      else
        image_tag 'bar/gay.png', :title => 'gay bar'
      end
    end
  end

  def time_options
    times = ActiveSupport::OrderedHash.new
    TIMES_ARRAY.each_with_index do |t, index|
      times[t] = index * SpecialDay::AN_HALF_HOUR
    end
    times
  end
  
  def transform_time(time)
    SpecialDay.translate_time(time)
  end
  
  def date_select_options
    Location::DAYS.keys.sort.collect{|d| [Location::DAYS[d].to_s.titleize, d]}
  end
  
  def static_rating(value)
    whole = value.to_i
    rest = value - whole
    imgs = ""
    [0,1,2,3,4].each do |i|
      imgs += if whole > i
        "<img src='/images/star-on.png' alt='#{i}' title='#{i}' />"
      elsif value > i
        "<img src='/images/star-half.png' alt='#{i}' title='#{i}' />"
      else
        "<img src='/images/star-off.png' alt='#{i}' title='#{i}' />"
      end
    end
    imgs.html_safe
  end
  
end
