class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def initialize
    #Look through the db and assemble a list of possible ratings.
    assemble_ratings
    #enabled ratings checkboxes! Turn all on by default.
    @ratings_filter = @all_ratings 
    super
  end

#This method checks the database and assembles an instance variable array
#whose elements consist of the ratings present.   
  def assemble_ratings
    @all_ratings = Array.new
    ratings_movies = Movie.all
        ratings_movies.each do |movie|
          unless @all_ratings.include? movie.rating
            @all_ratings << movie.rating
      end
    end
  end
  
  
  def index
    
    #If the user checked any of the ratings boxes
    if params.has_key? :ratings
      @ratings_filter = params[:ratings].keys
    end
    @title_col_class = nil
    @date_col_class = nil
    @rating_col_class = nil
    #If rating or title are passed, order the elements as such! 
    #Otherwise, display the items as normal
    if params.has_key? :sort_by
        @sort_column = params[:sort_by]
      if params[:sort_by] == "rating"
        @rating_col_class = "hilite"
      elsif params[:sort_by] == "title"
        @title_col_class = "hilite"
      elsif params[:sort_by] == "release_date"
        @date_col_class = "hilite"
      end
        return @movies = Movie.order(params[:sort_by]).all
    end
    return @movies = Movie.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
