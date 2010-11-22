class SitemapController < ApplicationController
  caches_page :sitemap
  
  def sitemap
    headers["Content-Type"] = "text/xml"
    headers["Last-Modified"] = Location.last.created_at.httpdate    
    @places = Location.all
    @cities = City.all
  end

end
