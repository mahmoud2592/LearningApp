class Enrollment < ApplicationRecord
  belongs_to :talent
  belongs_to :learning_path
  belongs_to :learning_path_course # new association to next course

  validates :talent_id, uniqueness: { scope: :learning_path_id, message: "has already enrolled in this learning path" }
  validates :enrollment_date, presence: true
  validates_uniqueness_of :talent_id, scope: :learning_path_id

  scope :by_talent, ->(talent) { where(talent: talent) }
  scope :by_learning_path, ->(learning_path) { where(learning_path: learning_path) }
  scope :by_date, ->(date) { where(enrollment_date: date) }

  after_create :set_talent_courses
  after_create :update_views_count
  after_destroy :update_views_count

   # new method to update enrollment with next course
    def complete_course(learning_path_course)
      # Check if the course is the last in the learning path
      last_course = learning_path.learning_path_courses.maximum(:sequence)
      if last_course == learning_path_course.sequence
        self.completed = true
        self.completed_at = Time.zone.now
        self.save
      else
        # Set the next course in the learning path as the next course in the enrollment
        next_course = learning_path.learning_path_courses.find_by(sequence: learning_path_course.sequence + 1)
        self.learning_path_course = next_course
        self.save
      end
    end

    def current_course
      learning_path_course || learning_path.learning_path_courses.find_by(sequence: sequence)
    end

  private

  def set_talent_courses
    learning_path.courses.each do | course |
      CourseTalent.create(course: course, talent: talent, completed: false)
    end
  end

  def update_views_count
    learning_path.update(views_count: learning_path.enrollments.select(:talent_id).distinct.count) if learning_path.present?
  end
end
