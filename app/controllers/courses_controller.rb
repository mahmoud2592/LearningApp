class CoursesController < ApplicationController
  include CoursesIndexable

  before_action :set_course, only: [:show, :update, :destroy]

  def index
    @courses = Course.indexed_courses(params).page(params[:page]).per(params[:per_page] || 10)
    render json: @courses, include: [:learning_paths, :talents]
  end

  def show
    render json: @course, include: [:learning_paths, :talents]
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      render json: @course, status: :created
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      render json: @course, include: [:learning_paths, :talents]
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    head :no_content
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :description, :video_url, :duration, :difficulty, :price, :published, :learning_path_id, :author_id)
  end
end
