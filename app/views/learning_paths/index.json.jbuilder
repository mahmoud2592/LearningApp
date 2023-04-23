json.array! @learning_paths do |learning_path|
  json.id learning_path.id
  json.name learning_path.name
  json.description learning_path.description
  json.duration_in_weeks learning_path.duration_in_weeks
  json.difficulty_level learning_path.difficulty_level
  json.published learning_path.published
  json.views_count learning_path.views_count
  json.total_views_count learning_path.total_views_count
  json.average_rating learning_path.average_rating
  json.learning_path_courses learning_path.learning_path_course do |learning_path_course|
    json.extract! learning_path_course, :id, :course_id, :sequence, :required, :status, :start_date, :end_date, :rating, :completed_at
    json.completion_rate learning_path_course.completion_rate
  end
end
