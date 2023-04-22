class Enrollment < ApplicationRecord
  belongs_to :talent
  belongs_to :learning_path

  validates :talent_id, uniqueness: { scope: :learning_path_id, message: "has already enrolled in this learning path" }
  validates :enrollment_date, presence: true
  validates_uniqueness_of :talent_id, scope: :learning_path_id

  scope :by_talent, ->(talent) { where(talent: talent) }
  scope :by_learning_path, ->(learning_path) { where(learning_path: learning_path) }
  scope :by_date, ->(date) { where(enrollment_date: date) }

  after_create :update_views_count
  after_destroy :update_views_count

  private

  def update_views_count
    learning_path.update(views_count: learning_path.enrollments.select(:talent_id).distinct.count) if learning_path.present?
  end
end
