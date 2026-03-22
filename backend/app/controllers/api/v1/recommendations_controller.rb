class Api::V1::RecommendationsController < ApplicationController

  def index
    recommendations = Recommendation.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: recommendations
  end

  def favorites
    recommendations = Recommendation.where(favorite: true).order(created_at: :desc)
    render json: recommendations
  end

  def update
    rec = Recommendation.find(params[:id])

    if rec.update(favorite: params[:favorite])
      render json: rec
    else
      render json: { error: rec.errors.full_messages }, status: :unprocessable_content
    end
  end

end
