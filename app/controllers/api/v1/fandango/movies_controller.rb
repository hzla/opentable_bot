class Api::V1::Fandango::MoviesController < ApplicationController

  def index
  	lat = params[:lat]
  	lng = params[:lng]
  	start_time = params[:start_time]
  	movies = FandangoTools.movie_recs lat, lng, start_time
  	#sample call


  	render json: {movies: movies}
  end

end