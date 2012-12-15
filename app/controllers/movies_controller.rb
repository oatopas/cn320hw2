class MoviesController < ApplicationController



  def show

    id = params[:id] # retrieve movie ID from URI route

    @movie = Movie.find(id) # look up movie by unique ID

    # will render app/views/movies/show.<extension> by default

  end



  def index

       @sort = params[:sort]

       @ratings = params[:ratings] 



    if (@sort.nil?&&session[:sort].nil?&&@ratings.nil?&&session[:ratings].nil?)

        

       @movies = Movie.all

        

    else



      if @sort.nil?   

        @sort = session[:sort]

      else

        session[:sort] = @sort

      end



      if @ratings.nil?

        @ratings = session[:ratings]



      else

        session[:ratings] = @ratings

      end


      if @sort.nil?   

          @movies = Movie.find_all_by_rating(@ratings.keys)

      else

        if @ratings.nil?

          @movies = Movie.order(@sort)

        else

          @movies = Movie.order(@sort).find_all_by_rating(@ratings.keys)

        end

      end



    end



    @all_ratings = Movie.ratings.inject(Hash.new)do 

   |all_ratings, rating|

    all_ratings[rating] = @ratings.nil? ? 

    false : @ratings.has_key?(rating) 

    all_ratings

    end

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

