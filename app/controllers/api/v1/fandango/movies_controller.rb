class Api::V1::Fandango::MoviesController < ApplicationController

  def index
  	render json: {hi: true}
  end

end