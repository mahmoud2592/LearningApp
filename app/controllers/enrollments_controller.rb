class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :update, :destroy]

  def index
    @enrollments = Enrollment.includes(:talent, :learning_path)
    filter_enrollments
    render json: @enrollments, include: [:talent, :learning_path]
  end

  def show
    render json: @enrollment, include: [:talent, :learning_path]
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)

    if @enrollment.save
      render json: @enrollment, status: :created, include: [:talent, :learning_path]
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      render json: @enrollment, include: [:talent, :learning_path]
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @enrollment.destroy
    head :no_content
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def enrollment_params
    params.require(:enrollment).permit(:talent_id, :learning_path_id, :enrollment_date)
  end

  def filter_enrollments
    @enrollments = @enrollments.by_talent(params[:talent_id]) if params[:talent_id].present?
    @enrollments = @enrollments.by_learning_path(params[:learning_path_id]) if params[:learning_path_id].present?
    @enrollments = @enrollments.by_date(params[:date]) if params[:date].present?
  end
end
