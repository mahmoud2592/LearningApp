class Course < ApplicationRecord

  DIFFICULTIES_OPTIONS = %w(beginner intermediate advanced expert)
  before_validation :set_slug
  after_save :update_learning_path_duration

  attr_accessor :type  # add this line to define the virtual attribute


  belongs_to :author
  belongs_to :talent, class_name: 'Talent', optional: true
  has_many :talents

  belongs_to :learning_path, dependent: :destroy

  has_one_attached :multimedia_file

  has_many :learning_path_courses, dependent: :destroy
  has_many :learning_paths, through: :learning_path_courses
  has_many :course_talents, dependent: :destroy
  has_many :talents, through: :course_talents

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :difficulty, inclusion: { in: DIFFICULTIES_OPTIONS }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum difficulty: {
    beginner: 1,
    intermediate: 2,
    advanced: 3,
    expert: 4
  }

  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :by_difficulty, ->(level) { where(difficulty: level) }
  scope :by_learning_path, ->(learning_path_id) { where(learning_path_id: learning_path_id) }
  scope :by_author, ->(author_id) { where(author_id: author_id) }

  before_validation :set_slug, on: :create

  def set_slug
    self.slug ||= name.parameterize if name.present?
  end

  def self.indexed_courses(params)
    courses = includes(:learning_paths, :talents)
    courses = courses.published_or_unpublished(params[:published]) if params[:published].present?
    courses = courses.by_difficulty(params[:difficulty]) if params[:difficulty].present?
    courses = courses.by_learning_path(params[:learning_path_id]) if params[:learning_path_id].present?
    courses = courses.by_author(params[:author_id]) if params[:author_id].present?
    courses = courses.page(params[:page]).per(params[:per_page] || 10)
    courses
  end

  def author_talent
    talent || author&.talent
  end

  private

  def update_learning_path_duration
    if learning_paths.any?
      learning_paths.each do |learning_path|
        total_duration_in_hours = learning_path.courses.sum(:duration)
        total_duration_in_weeks = total_duration_in_hours / 60.0 / 7.0
        learning_path.update(duration_in_weeks: total_duration_in_weeks.ceil.nonzero? || 1)
      end
    end
  end
end
