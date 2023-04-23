class LearningPathsController < ApplicationController
  before_action :set_learning_path, only: [:show, :update, :destroy]

  def index
    @learning_paths = LearningPath.all

    # Filter by difficulty level
    if params[:difficulty_level].present?
      @learning_paths = @learning_paths.by_difficulty_level(params[:difficulty_level])
    end

    # Filter by published
    if params[:published]
      @learning_paths = @learning_paths.published
    end

    # Filter by search query
    if params[:q].present?
      @learning_paths = @learning_paths.search(params[:q])
    end

    # Sort by views count
    if params[:sort] == 'views'
      @learning_paths = @learning_paths.order(views_count: :desc)
    end

    @learning_paths = @learning_paths.page(params[:page]).per(params[:per_page])

    render :index, status: :ok
  end

  def show
    render :show, status: :ok
  end

  def create
    @learning_path = LearningPath.new(learning_path_params)

    if @learning_path.save
      render :show, status: :created
    else
      render json: @learning_path.errors, status: :unprocessable_entity
    end
  end

  def update
    if @learning_path.update(learning_path_params)
      render :show, status: :created
    else
      render json: @learning_path.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @learning_path.destroy
  end

  private

  def set_learning_path
    @learning_path = LearningPath.find_by(id: params[:id])
    raise HttpErrors::NotFoundError.new if @learning_path.nil?
  end

  def learning_path_params
    params.require(:learning_path).permit(:name, :description, :duration_in_weeks, :difficulty_level, :published, :views_count)
  end
end
