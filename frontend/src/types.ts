export interface VibeSession {
    id: number
    mood_input: string
    created_at: string
    recommendations?: Recommendation[]
}

export interface Recommendation {
    id: number
    vibe_session_id: number;
    artist: string;
    track: string;
    genre: string;
    reason: string;
    favorite: boolean;
    createdAt: string;
}