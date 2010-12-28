AutoHtml.add_filter(:red_cloth) do |text|
  RedCloth.new(text).to_html
end