class Talent < ApplicationRecord
  CATEGORIES_OPTIONS = %w(design development marketing business other)
  LEVELS_OPTIONS = %w(beginner intermediate advanced expert)

  has_many :course_talents, dependent: :destroy
  has_many :courses, through: :course_talents
  has_many :enrollments, dependent: :destroy
  has_many :learning_paths, through: :enrollments

  validates :name, presence: true
  validates :category, :level, presence: true
  validates :name, presence: true, uniqueness: true
  validates :category, inclusion: { in: CATEGORIES_OPTIONS }
  validates :level, inclusion: { in: LEVELS_OPTIONS }

  enum category: {
    design: 1,
    development: 2,
    marketing: 3,
    business: 4,
    other: 5
  }

  enum level: {
    beginner: 1,
    intermediate: 2,
    advanced: 3,
    expert: 4
  }

  before_destroy :check_for_courses

  scope :by_category, -> (category) { where(category: category) }
  scope :by_level, -> (level) { where(level: level) }

  def check_for_courses
    if courses.any?
      errors.add(:base, 'Cannot delete talent with associated courses')
      throw :abort
    end
  end

  def self.most_popular
    select('talents.*, COUNT(learning_path_courses.id) AS course_count')
      .includes(courses: :learning_path_courses)
      .group('talents.id')
      .order('course_count DESC')
  end
end
