json.array! @authors do |author|
  json.id author.id
  json.name author.name
  json.email author.email
  json.website_url author.website_url
end
