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
      render json: { error: vibe_session.errors.full_messages }, status: :unprocessable_content
      return
    end

    # 2. call Anthropic API
    client = Anthropic::Client.new(api_key: ENV["ANTHROPIC_API_KEY"])

    response = client.messages.create(
      model: "claude-haiku-4-5",
      max_tokens: 512,
      messages: [
        Anthropic::Models::MessageParam.new(
          role: "user",
          content: "You are a music recommendation engine. Given a mood or vibe, return exactly 6 music recommendations as a JSON array. Each object must have these exact keys: artist, track, genre, reason. Your response must be a raw JSON array only. Do not wrap in markdown. Do not include any explanation. Only output the JSON array itself. Mood: #{params[:mood_input]}")
      ]
    )

    # 3. parse the response
    raw = response.content.first.text
    cleaned = raw.gsub(/```json|```/, '').strip
    recommendations_data = JSON.parse(cleaned)

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
      render json: { error: vibe_session.errors.full_messages }, status: :unprocessable_content
    end
  end
end
