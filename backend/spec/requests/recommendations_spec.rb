# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Recommendations", type: :request do
  describe "GET /api/v1/recommendations" do
    it "returns all recommendations" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      Recommendation.create!(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: true
      )
      Recommendation.create!(
        vibe_session: vibe_session,
        artist: "The National",
        track: "Bloodbuzz Ohio",
        genre: "Indie Rock",
        reason: "Brooding and melancholic",
        favorite: false
      )

      get "/api/v1/recommendations"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end

    it "returns empty array when no recommendations exist" do
      get "/api/v1/recommendations"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "GET /api/v1/recommendations/favorites" do
    it "returns only favorited recommendations" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      Recommendation.create!(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: true
      )
      Recommendation.create!(
        vibe_session: vibe_session,
        artist: "The National",
        track: "Bloodbuzz Ohio",
        genre: "Indie Rock",
        reason: "Brooding and melancholic",
        favorite: false
      )

      get "/api/v1/recommendations/favorites"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
      expect(body.first["artist"]).to eq("Bon Iver")
    end

    it "returns empty array when no favorites exist" do
      get "/api/v1/recommendations/favorites"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  describe "PATCH /api/v1/recommendations/:id" do
    it "marks a recommendation as a favorite" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      recommendation = Recommendation.create!(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: false
      )

      patch "/api/v1/recommendations/#{recommendation.id}", params: { favorite: true }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["favorite"]).to eq(true)
    end

    it "unmarks a recommendation as a favorite" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      recommendation = Recommendation.create!(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: true
      )

      patch "/api/v1/recommendations/#{recommendation.id}", params: { favorite: false }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["favorite"]).to eq(false)
    end

    it "returns 404 when recommendation does not exist" do
      patch "/api/v1/recommendations/99999", params: { favorite: true }
      expect(response).to have_http_status(:not_found)
    end
  end
end
