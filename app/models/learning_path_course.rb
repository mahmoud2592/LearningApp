class LearningPathCourse < ApplicationRecord
  #Enum
  enum status: { not_started: 0, in_progress: 1, completed: 2 }

  # Associations
  belongs_to :learning_path
  belongs_to :course
  has_many :talents, through: :enrollments

  validates :course_id, uniqueness: { scope: :learning_path_id, case_sensitive: true }


  attr_accessor :number  # add this line to define the virtual attribute

  # Scopes
  scope :by_learning_path, -> (learning_path_id) { where(learning_path_id: learning_path_id) }
  scope :by_course, -> (course_id) { where(course_id: course_id) }
  scope :required, -> { where(required: true) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :with_rating, -> { where("rating IS NOT NULL") }
  scope :completed, -> { where.not(completed_at: nil) }

  # Callbacks
  after_create :update_learning_path_courses_count
  after_destroy :update_learning_path_courses_count

  def rating
    learning_path.learning_path_courses.with_rating.average(:rating)
  end

  def completion_rate
    total = learning_path.learning_path_courses.count
    completed = learning_path.learning_path_courses.completed.count
    total > 0 ? (completed.to_f / total) * 100 : 0
  end

  private

  # Method to update learning path courses count after create or destroy
  def update_learning_path_courses_count
    if learning_path.present?
      learning_path.update(courses_count: learning_path.learning_path_courses.count)
    end
  end

end
