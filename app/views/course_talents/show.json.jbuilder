json.extract! @course_talent, :id, :completed, :created_at, :updated_at
json.talent do
  json.extract! @course_talent.talent, :id, :name, :description, :category, :level, :website_url
end
json.course do
  json.extract! @course_talent.course, :id, :name, :description, :slug, :video_url, :duration, :difficulty, :price, :published, :created_at, :updated_at
  if @course_talent.course.author_talent.is_a?(Author)
    json.author_type :author
    json.author_talent @course_talent.course.author_talent, :id, :name, :email, :website_url, :type
  else
    json.author_type  :talent
    json.author_talent @course_talent.course.author_talent, :id, :name, :description, :category, :level, :website_url
  end
end
