class Api::V1::RecommendationsController < ApplicationController

  def index
    recommendations = Recommendation.where(favorite: true).order(created_at: :desc)
    render json: recommendations
  end

  def update
    rec = Recommendation.find(params[:id])

    if rec.update(favorite: params[:favorite])
      render json: rec
    else
      render json: { error: rec.errors.full_messages }, status: :unprocessable_entity
    end
  end

end
