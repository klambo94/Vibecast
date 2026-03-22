import { useState } from 'react'
import { Star } from 'lucide-react'
import { useVibeSession } from '../hooks/useVibeSession'
import './Home.css'
import './RecCard.css'
import type {Recommendation, VibeSession} from "../types.ts";
import {useRecommendations} from "../hooks/useRecommendations.tsx";

export default function Home() {
    const [moodInput, setMoodInput] = useState('')
    const [session, setSession] = useState<VibeSession | null>(null)
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)

    const { createSession } = useVibeSession()
    const { toggleFavorite } = useRecommendations()

    const handleToggleFavorite = async (rec: Recommendation) => {
        try {
            const updated = await toggleFavorite(rec.id, !rec.favorite)
            if (session) {
                setSession({
                    ...session,
                    recommendations: session.recommendations?.map(r =>
                        r.id === updated.id ? updated : r
                    )
                })
            }
        } catch (e) {
            console.error('Failed to toggle favorite', e)
        }
    }

    const validateMoodInput = (input: string): string | null => {
        if (!input.trim()) return 'Please describe your mood.'
        if (input.trim().length < 3) return 'Mood must be at least 3 characters.'
        if (input.trim().length > 200) return 'Mood must be under 200 characters.'
        if (!/^[a-zA-Z0-9\s.,!?'-]+$/.test(input)) return 'No special characters allowed.'
        return null
    }

    const handleSubmit = async () => {
        const validationError = validateMoodInput(moodInput)
        if (validationError) {
            setError(validationError)
            return
        }
        setLoading(true)
        setError(null)
        try {
            const newSession = await createSession(moodInput)
            setSession(newSession)
            setMoodInput('')
        } catch (e) {
            setError('Something went wrong. Please try again.')
        } finally {
            setLoading(false)
        }
    }



    return (
        <div>
            <span className="page-header">Find the music to fit your mood</span>

            <div className="input-container">
                <div className="input-row">
                    <input
                        className="vibe-input"
                        type="text"
                        value={moodInput}
                        onChange={e => setMoodInput(e.target.value)}
                        placeholder="Describe your mood or vibe..."
                        onKeyDown={e => e.key === 'Enter' && handleSubmit()}
                    />
                    <button className="btn-primary" onClick={handleSubmit} disabled={loading}>
                        {loading ? 'Finding...' : 'Find my vibe'}
                    </button>
                </div>
            </div>

            {session && (
                <div className="session-mood">Vibe: {session.mood_input}</div>
            )}

            {loading && (
                <div className="loading">
                    <h3>Loading...</h3>
                </div>
            )}

            {error && <p>{error}</p>}

            {session && !loading && (
                <div className="rec-container">
                    {session.recommendations?.map((rec, index) => (
                        <div
                            key={rec.id}
                            className="rec-card-wrapper"
                            style={{ animationDelay: `${index * 0.1}s` }}
                        >
                            <div className="rec-card">
                                <button className="btn-fav" onClick={() => handleToggleFavorite(rec)}>
                                    <Star fill={rec.favorite ? 'gold' : 'none'} stroke='gold' />
                                </button>
                                <h3>{rec.artist}</h3>
                                <p>{rec.track}</p>
                                <p>{rec.genre}</p>
                                <p className="p-rec">{rec.reason}</p>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    )
}