'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { COLORS } from '@/lib/colors'
import { createMatch, joinMatch, fetchLeagues } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'
import { useEffect } from 'react'
import type { League } from '@/types'

type Tab = 'create' | 'join'

export default function LobbyPage() {
  const router  = useRouter()
  const pending = useGameStore((s) => s.pending)
  const setPending = useGameStore((s) => s.setPending)

  const [tab,      setTab]      = useState<Tab>('create')
  const [joinCode, setJoinCode] = useState('')
  const [loading,  setLoading]  = useState(false)
  const [leagues,  setLeagues]  = useState<League[]>([])
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null)
  const [error,    setError]    = useState<string | null>(null)

  useEffect(() => {
    fetchLeagues().then((ls) => {
      setLeagues(ls)
      if (pending?.league) setSelectedLeague(pending.league)
      else if (ls.length) setSelectedLeague(ls[0])
    })
  }, [])

  async function handleCreate() {
    const league = selectedLeague
    if (!league) { setError('Select a league first'); return }
    setLoading(true)
    setError(null)
    try {
      const res = await createMatch({ league_id: league.id })
      setPending({ league, mode: 'h2h', category: null })
      router.push(`/match/${res.match_id}`)
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not create match')
    } finally {
      setLoading(false)
    }
  }

  async function handleJoin() {
    if (joinCode.trim().length < 6) { setError('Enter the 8-character join code'); return }
    setLoading(true)
    setError(null)
    try {
      const res = await joinMatch(joinCode.trim().toUpperCase())
      router.push(`/match/${res.match_id}`)
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Invalid code or match not found')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="max-w-md mx-auto px-4 py-10">
      <button onClick={() => router.back()} className="text-sm mb-6 transition-opacity hover:opacity-70" style={{ color: COLORS.textSecondary }}>
        ← Back
      </button>

      <h1 className="text-3xl font-black text-white tracking-tight mb-2">Head-to-Head</h1>
      <p className="text-sm mb-8" style={{ color: COLORS.textMuted }}>Challenge another player to a live 1v1 match</p>

      {/* Tabs */}
      <div className="flex rounded-xl p-1 mb-6" style={{ background: COLORS.surface }}>
        {(['create', 'join'] as Tab[]).map((t) => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className="flex-1 py-2.5 rounded-lg text-sm font-semibold transition-colors capitalize"
            style={{
              background: tab === t ? COLORS.gold : 'transparent',
              color:      tab === t ? '#000' : COLORS.textMuted,
            }}
          >
            {t === 'create' ? 'Create Match' : 'Join Match'}
          </button>
        ))}
      </div>

      {error && (
        <div className="mb-4 p-3 rounded-xl text-sm" style={{ background: 'rgba(239,68,68,0.1)', color: COLORS.error, border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </div>
      )}

      {tab === 'create' ? (
        <div className="space-y-4">
          <p className="text-sm leading-relaxed" style={{ color: COLORS.textSecondary }}>
            Create a match and share your join code with a friend. The game starts when they join.
          </p>

          {/* League selector */}
          <div className="space-y-2">
            {leagues.map((l) => (
              <button
                key={l.id}
                onClick={() => setSelectedLeague(l)}
                className="w-full rounded-xl px-4 py-3 text-sm font-semibold text-left border transition-all"
                style={{
                  background:   selectedLeague?.id === l.id ? 'rgba(245,197,24,0.1)' : COLORS.surface,
                  borderColor:  selectedLeague?.id === l.id ? COLORS.gold : COLORS.border,
                  color:        selectedLeague?.id === l.id ? COLORS.gold : COLORS.textSecondary,
                }}
              >
                {l.name}
              </button>
            ))}
          </div>

          <button
            onClick={handleCreate}
            disabled={loading || !selectedLeague}
            className="w-full rounded-2xl py-4 font-bold text-black transition-opacity disabled:opacity-50"
            style={{ background: COLORS.gold }}
          >
            {loading ? 'Creating…' : 'Create Match'}
          </button>
        </div>
      ) : (
        <div className="space-y-4">
          <p className="text-sm" style={{ color: COLORS.textSecondary }}>
            Enter the 8-character join code from your opponent.
          </p>
          <input
            type="text"
            value={joinCode}
            onChange={(e) => setJoinCode(e.target.value.toUpperCase())}
            placeholder="e.g. A1B2C3D4"
            maxLength={8}
            className="w-full rounded-xl px-4 py-4 text-xl font-bold tracking-widest outline-none border"
            style={{
              background:   COLORS.surface,
              borderColor:  COLORS.border,
              color:        COLORS.textPrimary,
            }}
          />
          <button
            onClick={handleJoin}
            disabled={loading}
            className="w-full rounded-2xl py-4 font-bold text-black transition-opacity disabled:opacity-50"
            style={{ background: COLORS.gold }}
          >
            {loading ? 'Joining…' : 'Join Match'}
          </button>
        </div>
      )}
    </div>
  )
}
