import {useEffect, useState} from "react";
import type {Recommendation} from "../types.ts";
import {getFavorites} from "../api/recommendations.ts";
import {Star} from "lucide-react";
import {useRecommendations} from "../hooks/useRecommendations.tsx";


export default function Favorites() {
    const [favorites, setFavorites] = useState<Recommendation[] | null>([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)
    const { toggleFavorite } = useRecommendations()

    useEffect(() => {
        const fetchFavorites = async () => {
            setLoading(true)
            try {
                const data = await getFavorites()
                setFavorites(data)
            } catch (error) {
                setError("Failed to load Favorite Recommendations")
                console.error(error)
            } finally {
                setLoading(false)
            }
        }
        fetchFavorites()
    }, [])

    const handleToggleFavorite = async (rec: Recommendation) => {
        try {
            const updated = await toggleFavorite(rec.id, !rec.favorite)
            setFavorites(prev =>
                prev?.map(r => r.id === updated.id ? updated : r) ?? []
            )
        } catch (e) {
            console.error('Failed to toggle favorite', e)
        }
    }
    if (loading) return <div className="loading"><h3>Loading...</h3></div>
    if (error) return <p>{error}</p>

    return (
        <div className="container">
            <span className="page-header">Your Favorite Recommendations</span>
            {favorites == null || favorites.length === 0 &&
                <p>No Recommendations yet. Go cast a vibe!</p>}

            <div className="favorites-body">
                <div className="rec-container">
                    {favorites?.map((fav, index) => (
                        <div
                            key={fav.id}
                            className="rec-card-wrapper"
                            style={{ animationDelay: `${index * 0.1}s` }}
                        >
                            <div className="rec-card">
                                <button className="btn-fav" onClick={() => handleToggleFavorite(fav)}>
                                    <Star fill={fav.favorite ? 'gold' : 'none'} stroke='gold' />
                                </button>
                                <h3>{fav.artist}</h3>
                                <p>{fav.track}</p>
                                <p>{fav.genre}</p>
                                <p className="p-rec">{fav.reason}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

        </div>



    )
}