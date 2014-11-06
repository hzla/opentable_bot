class Api::V1::Opentable::MealsController < ApplicationController

  def reserve
    meal = Opentable.new params
    status = meal.reserve
    render json: {success: status.to_json}
  end

  def cancel
    c_id = params[:c_id]
    Opentable.cancel Meal.where(confirmation_id: c_id).first
    render json: {success: true}
  end

  def modify
  end

end