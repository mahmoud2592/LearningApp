class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :update, :destroy]

  # GET /authors
  def index
    @authors = Author.all.page(params[:page]).per(params[:per_page] || 10)

    render :index, status: :ok
  end

  # GET /authors/1
  def show
    render :show, status: :ok
  end

  # POST /authors
  def create
    @author = Author.new(author_params)

    if @author.save
      render :show, status: :ok
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /authors/1
  def update
    if @author.update(author_params)
      render :show, status: :ok
    else
      render json: @author.errors, status: :unprocessable_entity
    end
  end

  # DELETE /authors/1
  def destroy
    @author.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find_by(id: params[:id])
      raise HttpErrors::NotFoundError.new if @author.nil?
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.require(:author).permit(:name, :email, :website_url)
    end
end
