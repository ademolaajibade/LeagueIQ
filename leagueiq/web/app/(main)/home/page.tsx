'use client'

import { useEffect, useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { fetchLeagues, fetchLeagueMastery, getQuestionOfTheDay, getUserStats, getLeaderboard } from '@/lib/api'
import { LEAGUE_GRADIENTS, LEAGUE_NAMES, COLORS, LEVEL_COLORS } from '@/lib/colors'
import { useGameStore } from '@/store/gameStore'
import type { Profile, League, LeagueMastery, Question } from '@/types'

export default function HomePage() {
  const router   = useRouter()
  const supabase = createClient()
  const setPending = useGameStore((s) => s.setPending)

  const [profile,     setProfile]     = useState<Profile | null>(null)
  const [leagues,     setLeagues]     = useState<League[]>([])
  const [mastery,     setMastery]     = useState<LeagueMastery[]>([])
  const [qotd,        setQotd]        = useState<Question | null>(null)
  const [qotdPick,    setQotdPick]    = useState<number | null>(null)
  const [stats,       setStats]       = useState<{ games_played: number; accuracy: number } | null>(null)
  const [rank,        setRank]        = useState<number | null>(null)
  const [lastSession, setLastSession] = useState<{ league_id: string; mode: string } | null>(null)
  const [loading,     setLoading]     = useState(true)

  const load = useCallback(async () => {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    const { data: p } = await supabase.from('profiles').select('*').eq('id', user.id).single()
    if (p) setProfile(p as Profile)

    const [ls, ms, q] = await Promise.all([
      fetchLeagues(),
      p ? fetchLeagueMastery(p.id) : Promise.resolve([]),
      getQuestionOfTheDay().catch(() => null),
    ])
    setLeagues(ls)
    setMastery(ms)
    setQotd(q?.question ?? null)
    setLoading(false)

    // secondary stats — don't block main render
    getUserStats()
      .then(s => setStats({ games_played: s.games_played, accuracy: s.accuracy }))
      .catch(() => {})
    getLeaderboard({ period: 'all_time', limit: 1 })
      .then(r => setRank(r.current_user_rank))
      .catch(() => {})

    const { data: sessions } = await supabase
      .from('game_sessions')
      .select('league_id, mode')
      .eq('user_id', user.id)
      .eq('status', 'completed')
      .order('completed_at', { ascending: false })
      .limit(1)
    if (sessions?.[0]) setLastSession(sessions[0])
  }, [])

  useEffect(() => { load() }, [load])

  function handleQotdAnswer(index: number) {
    if (qotdPick !== null || !qotd) return
    setQotdPick(index)
  }

  function getMasteryContext(leagueId: string): 'best' | 'weakest' | null {
    const withData = mastery.filter(m => m.categories_completed > 0)
    if (withData.length < 2) return null
    const sorted = [...withData].sort((a, b) => b.categories_completed - a.categories_completed)
    if (sorted[0].league_id === leagueId) return 'best'
    if (sorted[sorted.length - 1].league_id === leagueId) return 'weakest'
    return null
  }

  function handleLeagueClick(league: League) {
    setPending({ league, mode: 'quick_play', category: null })
    router.push('/play')
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  const xpPercent  = profile ? Math.min((profile.xp % 500) / 500 * 100, 100) : 0
  const levelColor = LEVEL_COLORS[profile?.level ?? 'Bronze'] ?? COLORS.gold
  const qotdLeague = qotd ? leagues.find(l => l.id === qotd.league_id) : null

  const statCells = [
    { label: 'Rank',     value: rank        ? `#${rank}`                        : '—' },
    { label: 'Accuracy', value: stats       ? `${Math.round(stats.accuracy)}%`  : '—' },
    { label: 'Games',    value: stats       ? stats.games_played.toLocaleString() : '—' },
  ]

  return (
    <div className="max-w-3xl mx-auto px-4 py-6 space-y-8">

      {/* Header + XP */}
      <div>
        <div className="flex items-start justify-between mb-4">
          <div>
            <p className="text-sm" style={{ color: COLORS.textMuted }}>Welcome back,</p>
            <p className="text-3xl font-black tracking-tight text-white">@{profile?.username}</p>
          </div>
          <div className="flex items-center gap-2">
            {profile && (
              <div
                className="px-3 py-1.5 rounded-lg text-xs font-bold border"
                style={{ color: levelColor, borderColor: levelColor + '40', background: levelColor + '15' }}
              >
                {profile.level}
              </div>
            )}
            {(profile?.streak ?? 0) > 0 && (
              <div
                className="px-3 py-1.5 rounded-lg text-xs font-bold border"
                style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
              >
                🔥 {profile?.streak}d
              </div>
            )}
          </div>
        </div>

        {profile && (
          <div className="space-y-1.5">
            <div className="flex justify-between text-xs" style={{ color: COLORS.textMuted }}>
              <span>{profile.xp.toLocaleString()} XP</span>
              <span>{profile.level}</span>
            </div>
            <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
              <div
                className="h-full rounded-full transition-all duration-700"
                style={{ width: `${xpPercent}%`, background: levelColor }}
              />
            </div>
          </div>
        )}
      </div>

      {/* Stats strip */}
      <div className="grid grid-cols-3 rounded-2xl overflow-hidden border" style={{ borderColor: COLORS.border }}>
        {statCells.map(({ label, value }, i) => (
          <div
            key={label}
            className="py-4 flex flex-col items-center gap-1"
            style={{
              background:  COLORS.surface,
              borderRight: i < 2 ? `1px solid ${COLORS.border}` : 'none',
            }}
          >
            <span className="text-2xl font-black text-white">{value}</span>
            <span className="text-xs" style={{ color: COLORS.textMuted }}>{label}</span>
          </div>
        ))}
      </div>

      {/* QOTD Hero */}
      {qotd && (
        <section>
          <div className="flex items-center gap-2 mb-3">
            <div className="w-1.5 h-1.5 rounded-full animate-pulse" style={{ background: COLORS.gold }} />
            <p className="text-xs font-bold uppercase tracking-widest" style={{ color: COLORS.gold }}>
              Today's Question
            </p>
          </div>

          <div
            className="rounded-2xl overflow-hidden border"
            style={{ background: COLORS.surface, borderColor: COLORS.gold + '30' }}
          >
            <div className="px-5 pt-5 pb-4 border-b" style={{ borderColor: COLORS.border }}>
              {qotdLeague && (
                <p className="text-xs font-semibold mb-2" style={{ color: COLORS.textMuted }}>
                  {LEAGUE_NAMES[qotdLeague.slug]}
                </p>
              )}
              <p className="text-xl font-bold text-white leading-snug">{qotd.question}</p>
            </div>

            <div className="p-4 space-y-2">
              {qotd.options.map((opt, i) => {
                const picked    = qotdPick !== null
                const isCorrect = i === qotd.correct_answer
                const isPicked  = i === qotdPick

                let bg:         string = COLORS.surfaceAlt
                let borderClr:  string = 'transparent'
                let color:      string = COLORS.textSecondary
                let labelBg:    string = 'rgba(255,255,255,0.08)'
                let labelColor: string = color

                if (picked) {
                  if (isCorrect) {
                    bg = 'rgba(34,197,94,0.12)'; borderClr = COLORS.success
                    color = COLORS.success; labelBg = COLORS.success; labelColor = '#fff'
                  } else if (isPicked) {
                    bg = 'rgba(239,68,68,0.12)'; borderClr = COLORS.error
                    color = COLORS.error; labelBg = COLORS.error; labelColor = '#fff'
                  }
                }

                return (
                  <button
                    key={i}
                    onClick={() => handleQotdAnswer(i)}
                    disabled={picked}
                    className="w-full rounded-xl px-3 py-3 flex items-center gap-3 text-left transition-all hover:opacity-80"
                    style={{ background: bg, border: `1px solid ${borderClr}`, cursor: picked ? 'default' : 'pointer' }}
                  >
                    <span
                      className="w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0 transition-all"
                      style={{ background: labelBg, color: labelColor }}
                    >
                      {String.fromCharCode(65 + i)}
                    </span>
                    <span className="text-sm font-medium transition-colors" style={{ color }}>{opt}</span>
                  </button>
                )
              })}
            </div>

            {qotdPick !== null && qotd.fact && (
              <div className="mx-4 mb-3 rounded-xl p-3 border" style={{ background: COLORS.surfaceAlt, borderColor: COLORS.gold + '30' }}>
                <p className="text-xs font-bold uppercase tracking-wider mb-1" style={{ color: COLORS.gold }}>Did You Know?</p>
                <p className="text-sm leading-relaxed" style={{ color: COLORS.textSecondary }}>{qotd.fact}</p>
              </div>
            )}

            {qotdPick !== null && (
              <div className="px-4 pb-4">
                <button
                  onClick={() => router.push('/play')}
                  className="w-full rounded-xl py-3 text-sm font-bold transition-opacity hover:opacity-85"
                  style={{ background: COLORS.gold, color: '#000' }}
                >
                  Play More →
                </button>
              </div>
            )}
          </div>
        </section>
      )}

      {/* Leagues */}
      <section>
        <p className="text-xs font-bold uppercase tracking-widest mb-3" style={{ color: COLORS.textSecondary }}>
          Your Leagues
        </p>
        <div className="space-y-3">
          {leagues.map((league) => {
            const [from, to] = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
            const m       = mastery.find(x => x.league_id === league.id)
            const cats    = m?.categories_completed ?? 0
            const pct     = Math.round((cats / 7) * 100)
            const context = getMasteryContext(league.id)

            return (
              <button
                key={league.id}
                onClick={() => handleLeagueClick(league)}
                className="w-full rounded-2xl p-5 text-left transition-opacity hover:opacity-90 active:scale-[0.99]"
                style={{ background: `linear-gradient(135deg, ${from}, ${to})` }}
              >
                <div className="flex items-center justify-between">
                  <span className="text-white font-extrabold text-lg">
                    {LEAGUE_NAMES[league.slug] ?? league.name}
                  </span>
                  <div className="flex items-center gap-2">
                    {context === 'best' && (
                      <span
                        className="text-xs font-bold px-2 py-0.5 rounded-full"
                        style={{ background: 'rgba(34,197,94,0.25)', color: '#4ade80' }}
                      >
                        Your Best
                      </span>
                    )}
                    {context === 'weakest' && (
                      <span
                        className="text-xs font-bold px-2 py-0.5 rounded-full"
                        style={{ background: 'rgba(251,191,36,0.2)', color: '#fbbf24' }}
                      >
                        Needs Work
                      </span>
                    )}
                    <span className="text-white/70 text-2xl">›</span>
                  </div>
                </div>
                {m && (
                  <div className="mt-3 space-y-1">
                    <div className="flex justify-between text-xs text-white/60">
                      <span>{m.mastery_level}</span>
                      <span>{cats}/7 categories</span>
                    </div>
                    <div className="h-1 rounded-full overflow-hidden bg-white/20">
                      <div className="h-full rounded-full bg-white/70" style={{ width: `${pct}%` }} />
                    </div>
                  </div>
                )}
              </button>
            )
          })}
        </div>
      </section>

      {/* Continue */}
      {lastSession && (() => {
        const league = leagues.find(l => l.id === lastSession.league_id)
        if (!league) return null
        const [from, to]  = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
        const modeName    = lastSession.mode.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase())
        return (
          <section>
            <p className="text-xs font-bold uppercase tracking-widest mb-3" style={{ color: COLORS.textSecondary }}>
              Continue
            </p>
            <button
              onClick={() => handleLeagueClick(league)}
              className="w-full rounded-2xl p-5 flex items-center justify-between transition-opacity hover:opacity-90"
              style={{ background: `linear-gradient(135deg, ${from}22, ${to}22)`, border: `1px solid ${from}50` }}
            >
              <div className="text-left">
                <p className="text-white font-bold">{LEAGUE_NAMES[league.slug]}</p>
                <p className="text-sm mt-0.5" style={{ color: COLORS.textMuted }}>{modeName}</p>
              </div>
              <span className="text-white/70 text-2xl">›</span>
            </button>
          </section>
        )
      })()}

    </div>
  )
}
