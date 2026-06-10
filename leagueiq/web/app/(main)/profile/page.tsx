'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { COLORS, LEAGUE_NAMES, LEAGUE_COLORS, LEVEL_COLORS } from '@/lib/colors'
import { getUserStats, fetchLeagues, fetchLeagueMastery, createPayment } from '@/lib/api'
import type { Profile, League, LeagueMastery } from '@/types'

interface Stats {
  games_played: number
  accuracy: number
  best_streak: number
  xp_total: number
}

interface Subscription {
  plan: string
  expires_at: string | null
}

export default function ProfilePage() {
  const router   = useRouter()
  const supabase = createClient()

  const [profile,      setProfile]      = useState<Profile | null>(null)
  const [stats,        setStats]        = useState<Stats | null>(null)
  const [leagues,      setLeagues]      = useState<League[]>([])
  const [mastery,      setMastery]      = useState<LeagueMastery[]>([])
  const [subscription, setSubscription] = useState<Subscription | null>(null)
  const [loading,      setLoading]      = useState(true)
  const [upgrading,    setUpgrading]    = useState(false)
  const [error,        setError]        = useState<string | null>(null)

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) return
      const { data: p } = await supabase.from('profiles').select('*').eq('id', user.id).single()
      if (!p) return
      setProfile(p as Profile)

      const [s, ls, ms, subRes] = await Promise.all([
        getUserStats(),
        fetchLeagues(),
        fetchLeagueMastery(p.id),
        supabase.from('subscriptions').select('plan,expires_at').eq('user_id', user.id).maybeSingle(),
      ])
      setStats(s)
      setLeagues(ls)
      setMastery(ms)
      if (subRes.data) setSubscription(subRes.data as Subscription)
      setLoading(false)
    }
    load()
  }, [])

  async function handleUpgrade(plan: 'monthly' | 'yearly') {
    setUpgrading(true)
    setError(null)
    try {
      const { payment_url } = await createPayment({ plan })
      window.location.href = payment_url
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Payment failed')
      setUpgrading(false)
    }
  }

  async function signOut() {
    await supabase.auth.signOut()
    router.push('/login')
  }

  function getMastery(leagueId: string) {
    return mastery.find((m) => m.league_id === leagueId)
  }

  if (!profile || loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  const levelColor = LEVEL_COLORS[profile.level] ?? COLORS.gold
  const xpPercent  = Math.min((profile.xp % 500) / 500 * 100, 100)

  return (
    <div className="max-w-2xl mx-auto px-4 py-6 space-y-6">

      {/* Hero */}
      <div className="flex flex-col items-center gap-3">
        <div
          className="w-20 h-20 rounded-full flex items-center justify-center text-3xl font-black border-2"
          style={{ background: COLORS.surfaceAlt, borderColor: COLORS.gold, color: COLORS.gold }}
        >
          {profile.username[0]?.toUpperCase()}
        </div>
        <p className="text-2xl font-black text-white">@{profile.username}</p>
        {profile.streak > 0 && (
          <span
            className="px-3 py-1.5 rounded-lg text-sm font-bold border"
            style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
          >
            🔥 {profile.streak} day streak
          </span>
        )}
      </div>

      {/* Level + XP */}
      <div
        className="rounded-2xl p-5 border space-y-3"
        style={{ background: COLORS.surface, borderColor: COLORS.border }}
      >
        <div className="flex items-center justify-between">
          <div
            className="px-3 py-1.5 rounded-lg text-sm font-bold border"
            style={{ color: levelColor, borderColor: levelColor + '40', background: levelColor + '15' }}
          >
            {profile.level}
          </div>
          <span className="text-sm font-semibold" style={{ color: COLORS.textMuted }}>
            {profile.xp.toLocaleString()} XP
          </span>
        </div>
        <div className="h-2 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
          <div
            className="h-full rounded-full transition-all duration-700"
            style={{ width: `${xpPercent}%`, background: levelColor }}
          />
        </div>
      </div>

      {/* Stats */}
      {stats && (
        <div className="grid grid-cols-2 gap-3">
          {[
            { label: 'Games',    value: stats.games_played },
            { label: 'Accuracy', value: `${stats.accuracy}%` },
            { label: 'Streak',   value: stats.best_streak },
            { label: 'XP',       value: stats.xp_total.toLocaleString() },
          ].map((s) => (
            <div
              key={s.label}
              className="rounded-2xl p-5 border text-center"
              style={{ background: COLORS.surface, borderColor: COLORS.border }}
            >
              <p className="text-3xl font-black text-white">{s.value}</p>
              <p className="text-xs mt-1" style={{ color: COLORS.textMuted }}>{s.label}</p>
            </div>
          ))}
        </div>
      )}

      {/* League mastery */}
      <section className="space-y-3">
        <p className="text-xs font-bold uppercase tracking-widest" style={{ color: COLORS.textSecondary }}>
          League Mastery
        </p>
        {leagues.map((league) => {
          const m      = getMastery(league.id)
          const level  = m?.mastery_level ?? 'Rookie'
          const cats   = m?.categories_completed ?? 0
          const pct    = Math.round((cats / 7) * 100)
          const accent = LEAGUE_COLORS[league.slug] ?? COLORS.gold
          return (
            <div
              key={league.id}
              className="rounded-2xl p-4 border flex items-center gap-4"
              style={{ background: COLORS.surface, borderColor: COLORS.border }}
            >
              <div className="w-28 flex-shrink-0">
                <p className="font-bold text-white text-sm">{LEAGUE_NAMES[league.slug]}</p>
                <p className="text-xs mt-0.5" style={{ color: COLORS.textMuted }}>{level}</p>
              </div>
              <div className="flex-1 space-y-1">
                <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
                  <div className="h-full rounded-full" style={{ width: `${pct}%`, background: accent }} />
                </div>
                <p className="text-xs" style={{ color: COLORS.textMuted }}>{cats}/7 categories</p>
              </div>
            </div>
          )
        })}
      </section>

      {/* Premium upgrade */}
      {!profile.is_premium && (
        <div
          className="rounded-2xl p-5 border space-y-4"
          style={{ background: 'rgba(245,197,24,0.06)', borderColor: 'rgba(245,197,24,0.25)' }}
        >
          <div>
            <p className="text-lg font-black" style={{ color: COLORS.gold }}>Go Premium ⭐</p>
            <p className="text-sm mt-1 leading-relaxed" style={{ color: COLORS.textSecondary }}>
              Unlock all categories, streak shields, 2× XP booster & more
            </p>
          </div>
          {error && (
            <p className="text-sm" style={{ color: COLORS.error }}>{error}</p>
          )}
          <div className="space-y-2.5">
            <button
              onClick={() => handleUpgrade('monthly')}
              disabled={upgrading}
              className="w-full rounded-xl py-3 font-bold border transition-opacity disabled:opacity-50"
              style={{ color: COLORS.gold, borderColor: COLORS.gold }}
            >
              ₦2,000 / month
            </button>
            <button
              onClick={() => handleUpgrade('yearly')}
              disabled={upgrading}
              className="w-full rounded-xl py-3 font-bold text-black transition-opacity disabled:opacity-50"
              style={{ background: COLORS.gold }}
            >
              {upgrading ? 'Opening payment…' : '₦18,000 / year · Save 25%'}
            </button>
          </div>
        </div>
      )}

      {profile.is_premium && (
        <button
          onClick={() => router.push('/premium')}
          className="w-full rounded-2xl p-4 border text-center font-bold transition-opacity hover:opacity-80"
          style={{ background: 'rgba(245,197,24,0.1)', borderColor: 'rgba(245,197,24,0.25)', color: COLORS.gold }}
        >
          ⭐ Premium Active
          {subscription?.expires_at && (
            <span className="block text-xs font-normal mt-1" style={{ color: COLORS.textMuted }}>
              Renews {new Date(subscription.expires_at).toLocaleDateString('en-NG', { day: 'numeric', month: 'short', year: 'numeric' })}
              {' · '}Manage →
            </span>
          )}
        </button>
      )}

      {/* Sign out */}
      <button
        onClick={signOut}
        className="w-full rounded-2xl py-3.5 font-semibold border"
        style={{ color: COLORS.textMuted, borderColor: COLORS.border }}
      >
        Sign Out
      </button>

    </div>
  )
}
