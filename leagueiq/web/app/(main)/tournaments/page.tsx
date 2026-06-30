'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { COLORS, LEAGUE_NAMES, LEAGUE_COLORS } from '@/lib/colors'
import { enterTournament } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'

interface Tournament {
  id: string
  name: string
  league_id: string
  starts_at: string
  ends_at: string
  status: 'upcoming' | 'active' | 'completed'
  leagues: { slug: string; name: string } | null
}

export default function TournamentsPage() {
  const router = useRouter()
  const { setSession } = useGameStore()
  const [tournaments, setTournaments] = useState<Tournament[]>([])
  const [loading, setLoading]         = useState(true)
  const [entering, setEntering]       = useState<string | null>(null)
  const [error, setError]             = useState<string | null>(null)

  useEffect(() => {
    const supabase = createClient()
    supabase
      .from('tournaments')
      .select('*, leagues(slug, name)')
      .eq('status', 'active')
      .order('ends_at', { ascending: true })
      .then(({ data, error: err }) => {
        if (!err && data) setTournaments(data as Tournament[])
        setLoading(false)
      })
  }, [])

  async function handleEnter(t: Tournament) {
    setEntering(t.id)
    setError(null)
    try {
      const res = await enterTournament(t.id)
      setSession(res.session, res.questions)
      router.push('/quiz')
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not enter tournament')
    } finally {
      setEntering(null)
    }
  }

  function formatDate(iso: string) {
    return new Date(iso).toLocaleDateString('en-NG', {
      day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit',
    })
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-extrabold tracking-tight mb-1" style={{ color: COLORS.textPrimary }}>
        Tournaments
      </h1>
      <p className="text-sm mb-8" style={{ color: COLORS.textMuted }}>
        Compete for the top spot in weekly competitions
      </p>

      {error && (
        <div className="rounded-xl p-4 mb-6 border" style={{ background: 'rgba(239,68,68,0.08)', borderColor: 'rgba(239,68,68,0.25)' }}>
          <p className="text-sm font-medium" style={{ color: COLORS.error }}>{error}</p>
        </div>
      )}

      {loading ? (
        <div className="flex justify-center py-16">
          <div className="w-8 h-8 rounded-full border-2 border-t-transparent animate-spin" style={{ borderColor: COLORS.gold, borderTopColor: 'transparent' }} />
        </div>
      ) : tournaments.length === 0 ? (
        <div className="flex flex-col items-center py-16 gap-3">
          <span className="text-5xl">🏆</span>
          <p className="text-lg font-bold" style={{ color: COLORS.textPrimary }}>No active tournaments</p>
          <p className="text-sm text-center" style={{ color: COLORS.textMuted }}>
            Check back soon — new tournaments start weekly.
          </p>
        </div>
      ) : (
        <div className="flex flex-col gap-4">
          {tournaments.map((t) => {
            const slug   = t.leagues?.slug ?? ''
            const accent = LEAGUE_COLORS[slug] ?? COLORS.gold
            const busy   = entering === t.id
            return (
              <div
                key={t.id}
                className="rounded-2xl p-5 border"
                style={{ background: COLORS.surface, borderColor: accent + '44' }}
              >
                <span
                  className="inline-block text-xs font-bold px-3 py-1 rounded-full mb-3"
                  style={{ background: accent + '1A', color: accent }}
                >
                  {LEAGUE_NAMES[slug] ?? t.leagues?.name ?? 'Tournament'}
                </span>
                <p className="text-lg font-extrabold mb-1" style={{ color: COLORS.textPrimary }}>
                  {t.name}
                </p>
                <p className="text-sm mb-4" style={{ color: COLORS.textMuted }}>
                  Ends {formatDate(t.ends_at)}
                </p>
                <button
                  onClick={() => handleEnter(t)}
                  disabled={busy}
                  className="w-full py-3 rounded-xl font-bold text-sm transition disabled:opacity-40"
                  style={{ background: accent, color: '#000' }}
                >
                  {busy ? 'Entering…' : 'Enter & Play'}
                </button>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
