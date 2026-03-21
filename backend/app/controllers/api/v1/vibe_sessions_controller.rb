class Api::V1::VibeSessionsController < ApplicationController
  def index
    vibe_sessions = VibeSession.all.order(created_at: :desc)
    render json: vibe_sessions
  end

  def show
    vibe_session = VibeSession.includes(:recommendations).find(params[:id])
    render json: vibe_session, include: [ :recommendations ]
  end

  def create
    # 1. grab mood_input from params
    vibe_session = VibeSession.new(mood_input: params[:mood_input])


    # validate first before hitting the API
    unless vibe_session.valid?
      render json: { error: vibe_session.errors.full_messages }, status: :unprocessable_entity
      return
    end

    # 2. call Anthropic API
    client = Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"])

    response = client.messages.create(
      model: "claude-haiku-4-5",
      max_tokens: 1024,
      messages: [
        Anthropic::Models::MessageParam.new(
          role: "user",
          content: "You are a music recommendation engine. Given a mood or vibe, return exactly 5 music recommendations as a JSON array. Each object must have: artist, track, genre, reason. Return only valid JSON, no explanation, no markdown. Mood: #{params[:mood_input]}"
        )
      ]
    )

    # 3. parse the response
    recommendations_data = JSON.parse(response.content.first.text)

    # 4. save vibe session + recommendations
    if vibe_session.save
      recommendations_data.each do |rec|
        vibe_session.recommendations.create!(
          artist: rec["artist"],
          track: rec["track"],
          genre: rec["genre"],
          reason: rec["reason"],
          favorite: false
        )
      end

      # 5. return JSON
      render json: vibe_session, include: :recommendations, status: :created
    else
      render json: { error: vibe_session.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
