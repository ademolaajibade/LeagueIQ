'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import { COLORS, LEAGUE_NAMES } from '@/lib/colors'
import { getLeaderboard, fetchLeagues } from '@/lib/api'
import type { LeaderboardResponse, League } from '@/types'

type Period = 'all_time' | 'weekly' | 'survival'

const PERIODS: { key: Period; label: string }[] = [
  { key: 'all_time', label: 'All Time' },
  { key: 'weekly',   label: 'Weekly'   },
  { key: 'survival', label: 'Survival' },
]

const MEDALS = ['🥇', '🥈', '🥉']

export default function LeaderboardPage() {
  const supabase = createClient()

  const [myUserId,  setMyUserId]  = useState<string | null>(null)
  const [leagues,   setLeagues]   = useState<League[]>([])
  const [leagueIdx, setLeagueIdx] = useState(-1)
  const [period,    setPeriod]    = useState<Period>('all_time')
  const [data,      setData]      = useState<LeaderboardResponse | null>(null)
  const [loading,   setLoading]   = useState(true)

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => setMyUserId(data.user?.id ?? null))
    fetchLeagues().then(setLeagues)
  }, [])

  useEffect(() => {
    setLoading(true)
    const leagueId = leagueIdx >= 0 ? leagues[leagueIdx]?.id : undefined
    getLeaderboard({ league_id: leagueId, period, limit: 50 })
      .then(setData)
      .finally(() => setLoading(false))
  }, [leagueIdx, period, leagues])

  const entries = data?.entries ?? []
  const myRank  = data?.current_user_rank ?? null
  const top3    = entries.slice(0, 3)
  const rest    = entries.slice(3)

  return (
    <div className="max-w-2xl mx-auto px-4 py-6">

      {/* Header */}
      <div className="flex items-center justify-between mb-5">
        <h1 className="text-3xl font-black text-white tracking-tight">Leaderboard</h1>
        {myRank != null && (
          <span
            className="text-sm font-bold px-3 py-1.5 rounded-lg border"
            style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
          >
            #{myRank} You
          </span>
        )}
      </div>

      {/* Period tabs */}
      <div className="flex gap-2 mb-3 overflow-x-auto pb-1">
        {PERIODS.map((p) => (
          <button
            key={p.key}
            onClick={() => setPeriod(p.key)}
            className="px-4 py-1.5 rounded-full text-sm font-semibold whitespace-nowrap border transition-colors"
            style={{
              background:  period === p.key ? COLORS.gold : COLORS.surface,
              borderColor: period === p.key ? COLORS.gold : COLORS.border,
              color:       period === p.key ? '#000' : COLORS.textMuted,
            }}
          >
            {p.label}
          </button>
        ))}
      </div>

      {/* League tabs */}
      <div className="flex gap-2 mb-6 overflow-x-auto pb-1">
        <button
          onClick={() => setLeagueIdx(-1)}
          className="px-4 py-1.5 rounded-full text-sm font-semibold whitespace-nowrap border transition-colors"
          style={{
            background:  leagueIdx === -1 ? COLORS.gold : COLORS.surface,
            borderColor: leagueIdx === -1 ? COLORS.gold : COLORS.border,
            color:       leagueIdx === -1 ? '#000' : COLORS.textMuted,
          }}
        >
          Global
        </button>
        {leagues.map((l, i) => (
          <button
            key={l.id}
            onClick={() => setLeagueIdx(i)}
            className="px-4 py-1.5 rounded-full text-sm font-semibold whitespace-nowrap border transition-colors"
            style={{
              background:  leagueIdx === i ? COLORS.gold : COLORS.surface,
              borderColor: leagueIdx === i ? COLORS.gold : COLORS.border,
              color:       leagueIdx === i ? '#000' : COLORS.textMuted,
            }}
          >
            {LEAGUE_NAMES[l.slug] ?? l.name}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="flex justify-center py-16">
          <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
        </div>
      ) : (
        <div className="space-y-3">

          {/* Podium */}
          {top3.length > 0 && (
            <div className="flex items-end justify-center gap-3 mb-6">
              {[top3[1], top3[0], top3[2]].filter(Boolean).map((entry, i) => {
                const rank  = i === 0 ? 2 : i === 1 ? 1 : 3
                const medal = MEDALS[rank - 1]
                const isMe  = entry?.user_id === myUserId
                return (
                  <div
                    key={entry?.user_id}
                    className="flex-1 flex flex-col items-center gap-2"
                    style={{ marginBottom: rank === 1 ? 16 : 0 }}
                  >
                    <span className="text-2xl">{medal}</span>
                    <div
                      className="w-full rounded-xl p-3 text-center border"
                      style={{
                        background:  COLORS.surface,
                        borderColor: isMe ? COLORS.gold : COLORS.border,
                      }}
                    >
                      <p className="font-bold text-white text-sm truncate">{entry?.profile?.username ?? '—'}</p>
                      <p className="font-black text-lg mt-1" style={{ color: COLORS.gold }}>
                        {period === 'weekly' ? entry?.weekly_score : entry?.total_score}
                      </p>
                    </div>
                  </div>
                )
              })}
            </div>
          )}

          {/* Rest of list */}
          {rest.map((entry) => {
            const isMe = entry.user_id === myUserId
            return (
              <div
                key={entry.id}
                className="flex items-center gap-3 rounded-2xl p-4 border"
                style={{
                  background:  COLORS.surface,
                  borderColor: isMe ? COLORS.gold : COLORS.border,
                }}
              >
                <span className="w-10 text-sm font-bold" style={{ color: COLORS.textMuted }}>
                  #{entry.rank}
                </span>
                <div className="flex-1 min-w-0">
                  <p className="font-semibold text-white truncate">{entry.profile?.username ?? '—'}</p>
                  <p className="text-xs mt-0.5 truncate" style={{ color: COLORS.textMuted }}>{entry.profile?.level ?? ''}</p>
                </div>
                <span className="font-black text-lg" style={{ color: COLORS.gold }}>
                  {period === 'weekly' ? entry.weekly_score : entry.total_score}
                </span>
              </div>
            )
          })}

          {entries.length === 0 && (
            <p className="text-center py-16 text-sm" style={{ color: COLORS.textMuted }}>
              No entries yet. Be the first!
            </p>
          )}

        </div>
      )}
    </div>
  )
}
