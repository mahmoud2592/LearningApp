json.array! @courses do |course|
  json.extract! course, :id, :name, :description, :slug, :video_url, :duration, :difficulty, :price, :published, :created_at, :updated_at
  if course.author_talent.is_a?(Author)
    json.author_type :author
    json.author_talent course.author_talent, :id, :name, :email, :website_url
  else
    json.author_type :talent
    json.author_talent course.author_talent, :id, :name, :description, :category, :level, :website_url
  end
  json.learning_paths course.learning_paths do |learning_path|
    json.extract! learning_path, :id, :name, :description
  end
  json.talents course.talents do |talent|
    json.extract! talent, :id, :name, :description, :category, :level, :website_url
  end
end
# , format: :json
