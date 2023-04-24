class CourseTalentsController < ApplicationController
  before_action :set_course_talent, only: [:show, :update, :destroy]

  # GET /course_talents
  def index
    @course_talents = CourseTalent.all.page(params[:page]).per(params[:per_page])

    render :index, status: :ok
  end

  # GET /course_talents/1
  def show
    render :show, status: :ok
  end

  # POST /course_talents
  def create
    @course_talent = CourseTalent.new(course_talent_params)

    if @course_talent.save
      render :show, status: :ok
    else
      render json: @course_talent.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /course_talents/1
  def update
    if @course_talent.update(course_talent_params)
      render :show, status: :ok
    else
      render json: @course_talent.errors, status: :unprocessable_entity
    end
  end

  # DELETE /course_talents/1
  def destroy
    @course_talent.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_talent
      @course_talent = CourseTalent.find_by(id: params[:id])
      raise HttpErrors::NotFoundError.new if @course_talent.nil?
    end

    # Only allow a list of trusted parameters through.
    def course_talent_params
      params.require(:course_talent).permit(:course_id, :talent_id, :completed)
    end
end
