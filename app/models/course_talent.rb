class CourseTalent < ApplicationRecord
  # Associations
  belongs_to :course
  belongs_to :talent

  # Scopes
  scope :by_course, -> (course_id) { where(course_id: course_id) }
  scope :by_talent, -> (talent_id) { where(talent_id: talent_id) }
  scope :required, -> { includes(:course).merge(Course.includes(:learning_path_courses).where(learning_path_courses: { required: true })) }

  # A method to check if a talent is required for a course
  def required?
    course.learning_path_courses.find_by(course_id: course.id)&.required
  end

  # A method to calculate the duration of a course talent
  def duration
    course.duration * talent.level_before_type_cast
  end

  # Callbacks
  after_save :is_completed

  private

  def is_completed
    if completed == true
      course.learning_path_courses.each do |learning_path_course|
        learning_path_course.complete_for_talent(talent)
      end
      update_course_difficulty
    end
  end

  # Method to update course difficulty when a talent is added or removed
  def update_course_difficulty
    total_levels = course.course_talents.sum { |ct| ct.talent.level_before_type_cast }
    talent_count = course.course_talents.ids.count
    average_level = talent_count > 0 ? (total_levels.to_f / talent_count) : 1
    course.update(difficulty: average_level.round)
  end
end
