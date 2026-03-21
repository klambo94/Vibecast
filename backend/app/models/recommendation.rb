class Recommendation < ApplicationRecord
  belongs_to :vibe_session
  validates :artist, presence: true
  validates :track, presence: true
  validates :genre, presence: true
  validates :reason, presence: true
end
