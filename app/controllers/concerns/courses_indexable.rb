# app/controllers/concerns/courses_indexable.rb
module CoursesIndexable
  extend ActiveSupport::Concern

  included do
    def indexed_courses
      Course.indexed_courses(params).page(params[:page]).per(params[:per_page] || 10)
    end
  end
end
