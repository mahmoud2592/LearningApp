json.array! @enrollments do |enrollment|
  json.(enrollment, :id, :enrollment_date)
  json.talent enrollment.talent.name
  json.learning_path enrollment.learning_path.name
end
