import { useState } from 'react'
import {CircleArrowDown, CircleChevronUp, Star} from 'lucide-react'
import { useVibeSession } from '../hooks/useVibeSession'
import { useRecommendations } from '../hooks/useRecommendations'
import type { Recommendation, VibeSession } from '../types'
import './History.css'
import './RecCard.css'

export default function History() {
    const [expandedSession, setExpandedSession] = useState<VibeSession | null>(null)
    const { sessions, loading, error, fetchFullSession } = useVibeSession()
    const { toggleFavorite } = useRecommendations()

    const handleExpand = async (session: VibeSession) => {
        if (expandedSession?.id === session.id) {
            setExpandedSession(null)
            return
        }
        const full = await fetchFullSession(session.id)
        setExpandedSession(full)
    }

    const handleToggleFavorite = async (rec: Recommendation) => {
        try {
            const updated = await toggleFavorite(rec.id, !rec.favorite)
            if (expandedSession) {
                setExpandedSession({
                    ...expandedSession,
                    recommendations: expandedSession.recommendations?.map(r =>
                        r.id === updated.id ? updated : r
                    )
                })
            }
        } catch (e) {
            console.error('Failed to toggle favorite', e)
        }
    }

    if (loading) return <div className="loading"><h3>Loading...</h3></div>
    if (error) return <p>{error}</p>

    return (
        <div className="history-container">
            <span className="page-header">Your Vibe History</span>
            {sessions.length === 0 && <p>No sessions yet. Go cast a vibe!</p>}
            <div className="history-body">
                {sessions.map(session => (
                    <div key={session.id} className="history-item">
                        <div className="history-header" onClick={() => handleExpand(session)}>
                            <span className="history-mood">{session.mood_input}</span>
                            <span className="history-date">{new Date(session.created_at).toLocaleDateString()}</span>
                            <span className="history-expand">{expandedSession?.id === session.id ? <CircleChevronUp size={15}/> : <CircleArrowDown size={17}/>}</span>
                        </div>

                        {expandedSession?.id === session.id && (
                            <div className="rec-container">
                                {expandedSession.recommendations?.map((rec, index) => (
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
                ))}
            </div>

        </div>
    )
}