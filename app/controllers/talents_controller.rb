class TalentsController < ApplicationController
  before_action :set_talent, only: [:show, :update, :destroy]

  # GET /talents
  def index
    @talents = Talent.all.page(params[:page]).per(params[:per_page] || 10)
    render :index, status: :ok
  end

  # GET /talents/:id
  def show
    render :show, status: :ok
  end

  # POST /talents
  def create
    @talent = Talent.new(talent_params)

    if @talent.save
      render :show, status: :ok
    else
      render json: @talent.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /talents/:id
  def update
    if @talent.update(talent_params)
      render :show, status: :ok
    else
      render json: @talent.errors, status: :unprocessable_entity
    end
  end

  # DELETE /talents/:id
  def destroy
    @talent.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_talent
    @talent = Talent.find_by(id: params[:id])
    raise HttpErrors::NotFoundError.new if @talent.nil?
  end

  # Only allow a list of trusted parameters through.
  def talent_params
    params.require(:talent).permit(:name, :description, :category, :level, :website_url)
  end
end
