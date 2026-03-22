# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VibeSession, type: :model do
  describe "validations" do
    it "is valid with a mood_input" do
      vibe_session = VibeSession.new(mood_input: "rainy sunday morning")
      expect(vibe_session).to be_valid
    end

    it "is invalid with input under 3 characters" do
      vibe_session = VibeSession.new(mood_input: "hi")
      expect(vibe_session).not_to be_valid
    end

    it "is invalid with input over 200 characters" do
      vibe_session = VibeSession.new(mood_input: "a" * 201)
      expect(vibe_session).not_to be_valid
    end

    it "is invalid with special characters" do
      vibe_session = VibeSession.new(mood_input: "hello <script>")
      expect(vibe_session).not_to be_valid
    end

    it "is invalid without a mood_input" do
      vibe_session = VibeSession.new(mood_input: nil)
      expect(vibe_session).to_not be_valid
    end
  end

  describe 'associations' do
    it "has many recommendations" do
      vibe_session = VibeSession.new(mood_input: "rainy sunday morning")
      expect(vibe_session).to respond_to(:recommendations)
    end
  end
end
