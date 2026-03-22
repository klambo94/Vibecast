class VibeSession < ApplicationRecord
  has_many :recommendations, dependent: :destroy
  validates :mood_input, presence: true
  validates :mood_input, length: { minimum: 3, maximum: 200 }
  validates :mood_input, format: {
    with: /\A[a-zA-Z0-9\s.,!?'\-]+\z/,
    message: "contains invalid characters"
  }

  before_save :sanitize_mood_input

  private

  def sanitize_mood_input
    self.mood_input = mood_input.gsub(/[<>]/, '').strip
  end
end
