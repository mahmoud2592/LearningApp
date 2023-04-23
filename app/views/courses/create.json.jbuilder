# app/views/courses/show.json.jbuilder
json.extract! @course, :id, :name, :description, :slug, :video_url, :duration, :difficulty, :price, :published, :created_at, :updated_at
json.author @course.author_talent
