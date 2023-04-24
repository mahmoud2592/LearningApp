json.array! @enrollments do |enrollment|
  json.(enrollment, :id, :enrollment_date, :completed, :completed_at)
  json.current_course enrollment.current_course  unless enrollment.completed
  json.talent enrollment.talent, :id, :name, :description, :category, :level, :website_url
  json.learning_path do
    json.id enrollment.learning_path.id
    json.name enrollment.learning_path.name
    json.description enrollment.learning_path.description
    json.duration_in_weeks enrollment.learning_path.duration_in_weeks
    json.difficulty_level enrollment.learning_path.difficulty_level
    json.published enrollment.learning_path.published
    json.views_count enrollment.learning_path.views_count
    json.total_views_count enrollment.learning_path.total_views_count
    json.average_rating enrollment.learning_path.average_rating
  end
end
