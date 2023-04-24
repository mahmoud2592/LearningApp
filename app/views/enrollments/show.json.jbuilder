json.(@enrollment, :id, :enrollment_date, :completed, :completed_at)
json.current_course @enrollment.current_course unless @enrollment.completed
json.talent @enrollment.talent, :id, :name, :description, :category, :level, :website_url
json.learning_path do
  json.id @enrollment.learning_path.id
  json.name @enrollment.learning_path.name
  json.description @enrollment.learning_path.description
  json.duration_in_weeks @enrollment.learning_path.duration_in_weeks
  json.difficulty_level @enrollment.learning_path.difficulty_level
  json.published @enrollment.learning_path.published
  json.views_count @enrollment.learning_path.views_count
  json.total_views_count @enrollment.learning_path.total_views_count
  json.average_rating @enrollment.learning_path.average_rating
  json.learning_path_courses @enrollment.learning_path.learning_path_courses do |learning_path_course|
    json.extract! learning_path_course, :id, :learning_path_id, :course_id, :sequence, :required, :status, :start_date, :end_date, :rating
    json.completion_rate learning_path_course.completion_rate
  end
end
