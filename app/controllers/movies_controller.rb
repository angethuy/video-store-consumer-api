class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data.as_json
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    existing_movie = Movie.find_by(external_id: params[:external_id])
    if !existing_movie
      movie = Movie.new(movie_params)
      if movie.save
        render json: movie.as_json(only: [:id]), status: :created
        return
      else
        render json: {
            ok: false,
            errors: movie.errors.messages
          }, status: :bad_request
        return
      end
    else
      existing_movie.inventory += params[:inventory].to_i
      existing_movie.save
      render json: movie.as_json(only: [:id]), status: :created
      return
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :overview, :release_date, :inventory, :image_url, :external_id)
  end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
