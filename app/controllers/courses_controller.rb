class CoursesController < ApplicationController
  include CoursesIndexable

  before_action :set_course, only: [:show, :update, :destroy]

  def index
    @courses = Course.indexed_courses(params).page(params[:page]).per(params[:per_page] || 10)
    render :index, status: :ok
  end

  def show
    render :show, status: :ok
  end

  def create
    @course = Course.new(course_params)

    if @course.save
      render :show, status: :ok
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def update
    if @course.update(course_params)
      render :show, status: :ok
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
    @course = Course.find_by(id: params[:id])
    raise HttpErrors::NotFoundError.new if @course.nil?
  end

  def course_params
    params.require(:course).permit(:name, :description, :video_url, :duration, :difficulty, :price, :published, :learning_path_id, :author_id)
  end
end
