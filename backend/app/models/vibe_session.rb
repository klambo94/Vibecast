class VibeSession < ApplicationRecord
  has_many :recommendations, dependent: :destroy
  validates :mood_input, presence: true
end
