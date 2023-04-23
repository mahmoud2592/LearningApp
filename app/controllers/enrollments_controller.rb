class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :update, :destroy]

  def index
    @enrollments = Enrollment.includes(:talent, :learning_path)
    filter_enrollments
    render :index, include: [:talent, :learning_path], status: :ok
  end

  def show
    render :show, include: [:talent, :learning_path], status: :ok
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)

    if @enrollment.save
      render :show, include: [:talent, :learning_path], status: :ok
    else
      render json: @enrollment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @enrollment.update(enrollment_params)
      render :show, include: [:talent, :learning_path], status: :ok
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
    @enrollment = Enrollment.find_by(id: params[:id])
    raise HttpErrors::NotFoundError.new if @enrollment.nil?
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
