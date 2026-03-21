# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VibeSession, type: :model do
  describe "validations" do
    it "is valid with a mood_input" do
      vibe_session = VibeSession.new(mood_input: "rainy sunday morning")
      expect(vibe_session).to be_valid
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
