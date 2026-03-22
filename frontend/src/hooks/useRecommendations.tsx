import { toggleFavorite as toggleFavoriteApi } from '../api/recommendations'
import type { Recommendation } from '../types'

export function useRecommendations() {
    const toggleFavorite = async (id: number, favorite: boolean): Promise<Recommendation> => {
        return await toggleFavoriteApi(id, favorite)
    }

    return { toggleFavorite }
}