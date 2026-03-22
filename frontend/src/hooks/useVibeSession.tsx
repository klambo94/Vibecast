import { useState, useEffect } from 'react'
import { getVibeSessions, getVibeSession, createVibeSession } from '../api/vibeSessions'
import type {VibeSession} from "../types.ts";

export function useVibeSession() {
    const [sessions, setSessions] = useState<VibeSession[]>([])
    const [loading, setLoading] = useState(false)
    const [error, setError] = useState<string | null>(null)

    useEffect(() => {
        const fetchSessions = async () => {
            setLoading(true)
            try {
                const data = await getVibeSessions()
                setSessions(data)
            } catch (e) {
                setError('Failed to load sessions')
                console.error(e)
            } finally {
                setLoading(false)
            }
        }
        fetchSessions()
    }, [])

    const fetchFullSession = async (id: number): Promise<VibeSession> => {
        return await getVibeSession(id)
    }

    const createSession = async (moodInput: string): Promise<VibeSession> => {
        return await createVibeSession(moodInput)
    }

    return { sessions, loading, error, fetchFullSession, createSession }
}