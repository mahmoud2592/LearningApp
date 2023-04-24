class LearningPathCourse < ApplicationRecord
  # Associations
  belongs_to :learning_path
  belongs_to :course
  has_many :talents, through: :enrollments
  has_many :enrollments, dependent: :nullify

  validates :course_id, uniqueness: { scope: :learning_path_id, case_sensitive: true }
  validates :sequence, presence: true, uniqueness: { scope: :learning_path_id }

  attr_accessor :number  # add this line to define the virtual attribute

  # Scopes
  scope :by_learning_path, -> (learning_path_id) { where(learning_path_id: learning_path_id) }
  scope :by_course, -> (course_id) { where(course_id: course_id) }
  scope :required, -> { where(required: true) }
  scope :with_rating, -> { where("rating IS NOT NULL") }

  # Callbacks
  before_create :set_sequence_number
  after_save :mark_completed_for_talents
  after_create :update_learning_path_courses_count
  after_destroy :update_learning_path_courses_count

  def rating
    learning_path.learning_path_courses.with_rating.average(:rating)
  end

  def completion_rate
    total = learning_path.learning_path_courses.count
    completed = learning_path.learning_path_courses.count
    total > 0 ? (completed.to_f / total) * 100 : 0
  end

  def complete_for_talent(talent)
    enrollment = enrollments.find_by(talent: talent)
    enrollment.complete_course(self) if enrollment.present?
  end

  private

  def mark_completed_for_talents
    enrollments.where(completed: false).where("learning_path_course_id <= ?", id).each do |enrollment|
      enrollment.complete_course(self)
    end
  end

  # Method to update learning path courses count after create or destroy
  def update_learning_path_courses_count
    if learning_path.present?
      learning_path.update(courses_count: learning_path.learning_path_courses.count)
    end
  end

  def set_sequence_number
    self.sequence = (learning_path.learning_path_courses.maximum(:sequence) || 0) + 1
  end
end
