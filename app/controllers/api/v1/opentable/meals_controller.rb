class Api::V1::Opentable::MealsController < ApplicationController

  def reserve
    OpentableTools.reserve params
  end

end