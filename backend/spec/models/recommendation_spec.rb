# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  describe "validations" do
    it "is valid with all required fields" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      recommendation = Recommendation.new(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric"
      )
      expect(recommendation).to be_valid
    end
    it "is valid with all required fields and is a favorite" do
      vibe_session = VibeSession.create!(mood_input: "rainy morning")
      recommendation = Recommendation.new(
        vibe_session: vibe_session,
        artist: "Bon Iver",
        track: "Holocene",
        genre: "Indie Folk",
        reason: "Melancholic and atmospheric",
        favorite: true
      )
      expect(recommendation).to be_valid
    end

    it "is invalid without a vibe_session" do
      recommendation = Recommendation.new(vibe_session: nil)
      expect(recommendation).not_to be_valid
    end

    it "is invalid without an artist" do
      recommendation = Recommendation.new(artist: nil)
      expect(recommendation).not_to be_valid
    end

    it "is invalid without a track" do
      recommendation = Recommendation.new(track: nil)
      expect(recommendation).not_to be_valid
    end

    it "is invalid without a genre" do
      recommendation = Recommendation.new(genre: nil)
      expect(recommendation).not_to be_valid
    end

    it "is invalid without a reason" do
      recommendation = Recommendation.new(reason: nil)
      expect(recommendation).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to a vibe_session" do
      recommendation = Recommendation.new
      expect(recommendation).to respond_to(:vibe_session)
    end
  end
end
