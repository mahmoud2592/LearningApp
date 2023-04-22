class TalentsController < ApplicationController
  before_action :set_talent, only: [:show, :update, :destroy]

  # GET /talents
  def index
    @talents = Talent.all.page(params[:page]).per(params[:per_page] || 10)
    render json: @talents
  end

  # GET /talents/:id
  def show
    render json: @talent
  end

  # POST /talents
  def create
    @talent = Talent.new(talent_params)

    if @talent.save
      render json: @talent, status: :created, location: @talent
    else
      render json: @talent.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /talents/:id
  def update
    if @talent.update(talent_params)
      render json: @talent
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
    @talent = Talent.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def talent_params
    params.require(:talent).permit(:name, :description, :category, :level, :website_url)
  end
end
