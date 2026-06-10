'use client'

import { useEffect, useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { fetchLeagues, fetchLeagueMastery, getQuestionOfTheDay } from '@/lib/api'
import { LEAGUE_GRADIENTS, LEAGUE_NAMES, COLORS, LEVEL_COLORS } from '@/lib/colors'
import { useGameStore } from '@/store/gameStore'
import type { Profile, League, LeagueMastery, Question } from '@/types'

export default function HomePage() {
  const router    = useRouter()
  const supabase  = createClient()
  const setPending = useGameStore((s) => s.setPending)

  const [profile,  setProfile]  = useState<Profile | null>(null)
  const [leagues,  setLeagues]  = useState<League[]>([])
  const [mastery,  setMastery]  = useState<LeagueMastery[]>([])
  const [qotd,     setQotd]     = useState<Question | null>(null)
  const [loading,  setLoading]  = useState(true)

  const load = useCallback(async () => {
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    const { data: p } = await supabase
      .from('profiles').select('*').eq('id', user.id).single()
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
  }, [])

  useEffect(() => { load() }, [load])

  function getMastery(leagueId: string) {
    return mastery.find((m) => m.league_id === leagueId) ?? null
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

  const xpPercent = profile ? Math.min((profile.xp % 500) / 500 * 100, 100) : 0
  const levelColor = LEVEL_COLORS[profile?.level ?? 'Bronze'] ?? COLORS.gold

  return (
    <div className="max-w-3xl mx-auto px-4 py-6 space-y-8">

      {/* Header */}
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm" style={{ color: COLORS.textMuted }}>Welcome back,</p>
          <p className="text-3xl font-black tracking-tight text-white">@{profile?.username}</p>
        </div>
        <div className="flex items-center gap-3">
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

      {/* XP bar */}
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

      {/* QOTD */}
      {qotd && (
        <section>
          <p className="text-xs font-bold uppercase tracking-widest mb-3" style={{ color: COLORS.textSecondary }}>
            Question of the Day
          </p>
          <div
            className="rounded-2xl p-5 border space-y-4"
            style={{ background: COLORS.surface, borderColor: COLORS.border }}
          >
            <p className="text-xs font-bold uppercase tracking-wider" style={{ color: COLORS.gold }}>
              {leagues.find((l) => l.id === qotd.league_id)
                ? LEAGUE_NAMES[leagues.find((l) => l.id === qotd.league_id)!.slug]
                : 'Football'}
            </p>
            <p className="text-lg font-semibold text-white leading-snug">{qotd.question}</p>
            <div className="grid grid-cols-2 gap-2">
              {qotd.options.map((opt, i) => (
                <div
                  key={i}
                  className="rounded-xl px-3 py-2.5 text-sm"
                  style={{ background: COLORS.surfaceAlt, color: COLORS.textSecondary }}
                >
                  <span className="font-bold mr-1">{String.fromCharCode(65 + i)}.</span>{opt}
                </div>
              ))}
            </div>
          </div>
        </section>
      )}

      {/* Leagues */}
      <section>
        <p className="text-xs font-bold uppercase tracking-widest mb-3" style={{ color: COLORS.textSecondary }}>
          Leagues
        </p>
        <div className="space-y-3">
          {leagues.map((league) => {
            const [from, to] = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
            const m = getMastery(league.id)
            const cats = m?.categories_completed ?? 0
            const pct  = Math.round((cats / 7) * 100)
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
                  <span className="text-white/70 text-2xl">›</span>
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

      {/* Quick actions */}
      <section>
        <p className="text-xs font-bold uppercase tracking-widest mb-3" style={{ color: COLORS.textSecondary }}>
          Quick Actions
        </p>
        <div className="grid grid-cols-3 gap-3">
          {[
            { icon: '⚡', label: 'Quick Play',      href: '/play' },
            { icon: '📅', label: 'Daily Challenge', href: '/play' },
            { icon: '🆚', label: 'Head-to-Head',    href: '/match/lobby' },
          ].map((a) => (
            <button
              key={a.label}
              onClick={() => router.push(a.href)}
              className="rounded-2xl py-4 flex flex-col items-center gap-2 border transition-opacity hover:opacity-80"
              style={{ background: COLORS.surface, borderColor: COLORS.border }}
            >
              <span className="text-2xl">{a.icon}</span>
              <span className="text-xs font-semibold text-center" style={{ color: COLORS.textSecondary }}>
                {a.label}
              </span>
            </button>
          ))}
        </div>
      </section>

    </div>
  )
}
