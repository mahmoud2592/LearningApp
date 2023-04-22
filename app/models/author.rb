class Author < ApplicationRecord
  before_destroy :transfer_courses_to_another_author

  has_many :courses

  # Scope to find authors who have published at least one course
  scope :with_published_courses, -> { includes(:courses).where(courses: { published: true }).group("authors.id").having("COUNT(courses.id) > 0") }

  # Callback to set website_url to "N/A" if left blank
  before_validation :set_website_url_to_na

  # Method to return a string of the author's name and email
  def name_and_email
    "#{name} <#{email}>"
  end

  private

  def transfer_courses_to_another_author
    if courses.any?
      another_author = Author.where.not(id: id).first
      if another_author
        courses.update_all(author_id: another_author.id)
      else
        raise "Cannot delete the only author in the system"
      end
    end
  end

  def set_website_url_to_na
    self.website_url = "N/A" if website_url.nil? || website_url.empty?
  end
end
