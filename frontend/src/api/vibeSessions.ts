import api from "./index.ts";
import type {VibeSession} from '../types.ts';
export const getVibeSessions = async(): Promise<VibeSession[]> => {
    const response = await api.get("/vibe_sessions")
    return response.data
}

export const getVibeSession = async (id: number): Promise<VibeSession> => {
    const response = await api.get(`/vibe_sessions/${id}`)
    return response.data
}

export const createVibeSession = async (moodInput: string): Promise<VibeSession> => {
    const response = await api.post("/vibe_sessions", {mood_input: moodInput})
    return response.data
}