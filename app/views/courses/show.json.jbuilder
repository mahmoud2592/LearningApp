json.extract! @course, :id, :name, :description, :slug, :video_url, :duration, :difficulty, :price, :published, :created_at, :updated_at
json.author @course.author_talent
json.learning_paths @course.learning_paths do |learning_path|
  json.extract! learning_path, :id, :name, :description
end
json.talents @course.talents do |talent|
  json.extract! talent, :id, :name, :description, :category, :level, :website_url
end
