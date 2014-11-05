class Api::V1::Opentable::MealsController < ApplicationController

  def reserve
    meal = OpentableTools.new params
    status = meal.reserve
    render json {success: status}
  end

  def cancel
    meal = OpentableTools.new params
    meal.cancel params
    render json {success: true}
  end

end