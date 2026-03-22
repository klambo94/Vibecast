import type {Recommendation} from "../types.ts";
import api from "./index.ts";


export const getRecommendations = async (): Promise<Recommendation[]> => {
    const response = await api.get("/recommendations")
    return response.data
}

export const getFavorites = async (): Promise<Recommendation[]> => {
    const response = await api.get("/recommendations/favorites")
    return response.data
}

export const toggleFavorite = async (id: number, favorite: boolean): Promise<Recommendation> => {
    const response = await api.patch(`recommendations/${id}`, {favorite})
    return response.data
}