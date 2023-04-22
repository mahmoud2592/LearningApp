json.array! @talents do |talent|
  json.extract! talent, :id, :name, :description, :category, :level, :website_url
end
