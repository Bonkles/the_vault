class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #If rating or title are passed, order the elements as such! 
    #Otherwise, display the items as normal

  @title_css_class = nil
  @rating_css_class = nil
  @release_date_css_class = nil

    if params.has_key? :sort_by
      if params[:sort_by] == "rating"
        @rating_css_class = "hilite"
        return @movies = Movie.order("rating").all
      elsif params[:sort_by] == "title"
        @sort_column = "title"
        @title_css_class = "hilite"
        return @movies = Movie.order("title").all
      elsif params[:sort_by] == "release_date"
        @sort_column = "release_date"
        @release_date_css_class="hilite"
        return @movies = Movie.order("release_date").all
      end
    end
    
    #If we didn't supply any type of key, we should default 
    #to returning the unsorted list o' movies
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
