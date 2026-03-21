class CreateRecommendations < ActiveRecord::Migration[8.1]
  def change
    create_table :recommendations do |t|
      t.references :vibe_session, null: false, foreign_key: true
      t.string :artist
      t.string :track
      t.string :genre
      t.text :reason
      t.boolean :favorited

      t.timestamps
    end
  end
end
