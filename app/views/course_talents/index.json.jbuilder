json.array! @course_talents do |course_talent|
  json.extract! course_talent, :id, :course_id, :talent_id, :completed, :created_at, :updated_at
end
