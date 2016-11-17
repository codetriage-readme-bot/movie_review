class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def search
    if params[:search].present?
      @movies = Movie.search(params[:search])
    else
      @movies = Movie.all
    end
  end

  
  def index
    @movies = Movie.all
  end

  
  def show
    @reviews = Review.where(movie_id: @movie.id).order("created_at DESC")

    if @reviews.blank?
      @avg_review = 0
    else
      @avg_review = @reviews.average(:rating).round(2)
    end
  end

  
  def new
    @movie = current_user.movies.build
  end

 
  def edit
  end

  
  def create
    @movie = current_user.movies.build(movie_params)

    if @movie.save
      redirect_to movie_path(@movie.id)
    else
      render "new"
    end
  end

 
  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie.id)
    else
      render "edit"
    end
  end

  
  def destroy
    @movie.destroy
    redirect_to root_path
  end

  private
    
  def set_movie
    @movie = Movie.find(params[:id])
  end

    
  def movie_params
    params.require(:movie).permit(:title, :description, :movie_length, :director, :rating, :image)
  end
end
