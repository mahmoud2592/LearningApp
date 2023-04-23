class LearningPath < ApplicationRecord
  DIFFICULTIES_OPTIONS = %w(beginner intermediate advanced expert)

  has_many :enrollments, dependent: :destroy
  has_many :talents, through: :enrollments
  has_many :learning_path_courses, dependent: :destroy
  has_many :courses, through: :learning_path_courses

  validates :name, presence: true
  validates :duration_in_weeks, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty_level, inclusion: { in: DIFFICULTIES_OPTIONS }
  validates :description, presence: true
  validates :published, inclusion: { in: [true, false] }
  validates :views_count, numericality: { greater_than_or_equal_to: 0 }
  # validates :image_url, format: { with: /\Ahttp(s)?:\/\/[^\s]+\z/i }, allow_blank: true

  enum difficulty_level: {
    beginner: 1,
    intermediate: 2,
    advanced: 3,
    expert: 4
  }

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :popular, -> { where('views_count >= ?', 100) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :by_difficulty_level, ->(difficulty_level) { where(difficulty_level: difficulty_level) }


  before_save :set_duration_in_weeks

  def set_duration_in_weeks
    total_duration_in_hours = self.courses.sum(:duration)
    total_duration_in_weeks = total_duration_in_hours / 60.0 / 7.0
    self.duration_in_weeks = total_duration_in_weeks.ceil.nonzero? || 1
  end

  def total_views_count
    self.views_count
  end

  def average_rating
    self.learning_path_courses.average(:rating)
  end

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end

  def self.random
    order(Arel.sql('RANDOM()')).first
  end
end
