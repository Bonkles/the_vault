class MoviesController < ApplicationController
before_filter :assemble_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

#This method checks the database and assembles an instance variable array
#whose elements consist of the ratings present.   
  def assemble_ratings
    @all_ratings = Hash.new
    ratings_movies = Movie.all
        ratings_movies.each do |movie|
          unless @all_ratings.keys.include? movie.rating
            @all_ratings[movie.rating] = 1
      end
    end
    @ratings_filter = @all_ratings
  end
  
  def index
    if params.has_key? :ratings
      #if they passed in a hash, we are only interested in the keys. This is what we get if we click the submit button in the top form. 
      @ratings_filter = params[:ratings]
      session[:ratings] = params[:ratings] #save these params in the session. 
    elsif session.has_key? :ratings
        @ratings_filter = session[:ratings]
      #Since we didn't supply the string in the params, we need to provide a RESTful route!
      flash.keep
#      redirect_to
    end

    #If rating or title are passed, order the elements as such! 
    if params.has_key? :sort_by
      @sort_column = params[:sort_by]
      session[:sort_by] = @sort_column
    elsif session.has_key? :sort_by #If there was no key passed in via the URI, use the session info instead.
      @sort_column = session[:sort_by]      
    end

    movie_query = Movie.where(:rating => @ratings_filter.keys)
    if (@sort_column == nil)
      @movies = movie_query.all
    else
      @movies = movie_query.order(@sort_column).all
    end
    
    @movies
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
