class Api::V1::Fandango::MoviesController < ApplicationController

  def index
  	lat = params[:lat]
  	lng = params[:lng]
  	start_time = params[:start_time]
  	start_date = params[:start_date]
  	movies = FandangoTools.movie_recs lat, lng, start_time, start_date
  	#sample call https://hidden-bastion-8862.herokuapp.com/api/v1/fandango/movies?lat=34&lng=-118&start_time=01:00
  	# returns a 2-d array, each sub-array contains the movie name as first element
  	# and collection of data in second


  	render json: {movies: movies}
  end

end