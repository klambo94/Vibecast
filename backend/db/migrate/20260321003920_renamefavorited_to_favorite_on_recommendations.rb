class RenamefavoritedToFavoriteOnRecommendations < ActiveRecord::Migration[8.1]
  def change
    rename_column :recommendations, :favorited, :favorite
  end
end
