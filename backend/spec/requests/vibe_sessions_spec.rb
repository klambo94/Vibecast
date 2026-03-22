# frozen_string_literal: true

RSpec.describe "Api::V1::VibeSessions", type: :request do
  describe "GET /api/v1/vibe_sessions" do
    it "returns all vibe sessions" do
      VibeSession.create!(mood_input: "rainy morning")
      VibeSession.create!(mood_input: "sunny afternoon")

      get "/api/v1/vibe_sessions"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).length).to eq(2)
    end
  end

  describe "GET /api/v1/vibe_sessions/:id" do
    it "returns a vibe session with recommendations" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      Recommendation.create!(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: false
      )

      get "/api/v1/vibe_sessions/#{vibe_session.id}"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["mood_input"]).to eq("rainy morning")
      expect(body["recommendations"].length).to eq(1)
    end

    it "returns 404 when session does not exist" do
      get "/api/v1/vibe_sessions/99999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/vibe_sessions" do
    it "creates a vibe session and returns recommendations" do
      stub_request(:post, "https://api.anthropic.com/v1/messages")
        .to_return(
          status: 200,
          body: {
            content: [
              {
                text: '[{"artist":"Bon Iver","track":"Holocene","genre":"Indie Folk","reason":"Melancholic and atmospheric"}]'
              }
            ]
          }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      post "/api/v1/vibe_sessions", params: { mood_input: "rainy morning" }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["mood_input"]).to eq("rainy morning")
      expect(body["recommendations"].length).to eq(1)
    end

    it "returns an error without mood_input" do
      post "/api/v1/vibe_sessions", params: { mood_input: nil }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end
end