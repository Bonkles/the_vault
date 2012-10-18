class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @title_col_class = nil
    @date_col_class = nil
    @rating_col_class = nil
    #If rating or title are passed, order the elements as such! 
    #Otherwise, display the items as normal
    if params.has_key? :sort_by
      if params[:sort_by] == "rating"
        @sort_column = "rating"
        @rating_col_class = "hilite"
        return @movies = Movie.order("rating").all
      elsif params[:sort_by] == "title"
        @sort_column = "title"
        @title_col_class = "hilite"
        return @movies = Movie.order("title").all
      elsif params[:sort_by] == "release_date"
        @sort_column = "release_date"
        @date_col_class = "hilite"
        return @movies = Movie.order("release_date").all
      else
      end
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
