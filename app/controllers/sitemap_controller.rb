class SitemapController < ApplicationController
  
  def sitemap
    headers["Content-Type"] = "text/xml"
    headers["Last-Modified"] = Time.now.httpdate    
    @places = Location.all
    @cities = City.all
  end
  
end
