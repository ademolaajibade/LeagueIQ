'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { COLORS } from '@/lib/colors'
import { createPayment, verifyPayment, activateXpBooster } from '@/lib/api'
import type { Profile } from '@/types'

interface Subscription {
  plan: string
  status: string
  expires_at: string | null
  started_at: string
}

function formatDate(iso: string | null) {
  if (!iso) return '—'
  return new Date(iso).toLocaleDateString('en-NG', { day: 'numeric', month: 'long', year: 'numeric' })
}

function boosterLabel(expiresAt: string | null): string {
  if (!expiresAt) return 'Not active'
  const remaining = new Date(expiresAt).getTime() - Date.now()
  if (remaining <= 0) return 'Expired'
  const hrs = Math.floor(remaining / 3_600_000)
  const mins = Math.floor((remaining % 3_600_000) / 60_000)
  return hrs > 0 ? `Active · ${hrs}h ${mins}m left` : `Active · ${mins}m left`
}

export default function PremiumPage() {
  const router   = useRouter()
  const supabase = createClient()

  const [profile,      setProfile]      = useState<Profile | null>(null)
  const [subscription, setSubscription] = useState<Subscription | null>(null)
  const [loading,      setLoading]      = useState(true)
  const [upgrading,    setUpgrading]    = useState(false)
  const [boosting,     setBoosting]     = useState(false)
  const [boosterExpiry, setBoosterExpiry] = useState<string | null>(null)
  const [error,        setError]        = useState<string | null>(null)
  const [notice,       setNotice]       = useState<string | null>(null)

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) { router.replace('/login'); return }

      const [profileRes, subRes] = await Promise.all([
        supabase.from('profiles').select('*').eq('id', user.id).single(),
        supabase.from('subscriptions').select('*').eq('user_id', user.id).single(),
      ])

      if (profileRes.data) {
        const p = profileRes.data as Profile
        setProfile(p)
        setBoosterExpiry((p as unknown as { xp_booster_expires_at: string | null }).xp_booster_expires_at)
      }
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
      setError(e instanceof Error ? e.message : 'Could not start payment')
      setUpgrading(false)
    }
  }

  async function handleBooster() {
    setBoosting(true)
    setError(null)
    setNotice(null)
    try {
      const { xp_booster_expires_at } = await activateXpBooster()
      setBoosterExpiry(xp_booster_expires_at)
      setNotice('2× XP Booster activated for 24 hours!')
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not activate booster')
    } finally {
      setBoosting(false)
    }
  }

  if (loading || !profile) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  const isPremium     = profile.is_premium
  const boosterActive = boosterExpiry ? new Date(boosterExpiry) > new Date() : false

  return (
    <div className="max-w-xl mx-auto px-4 py-6 space-y-6">
      <p className="text-2xl font-black text-white">Premium</p>

      {/* Error / Notice */}
      {error  && <p className="text-sm rounded-xl p-3" style={{ background: 'rgba(239,68,68,0.1)', color: COLORS.error }}>{error}</p>}
      {notice && <p className="text-sm rounded-xl p-3" style={{ background: 'rgba(245,197,24,0.1)', color: COLORS.gold }}>{notice}</p>}

      {/* Current status card */}
      <div
        className="rounded-2xl p-5 border space-y-3"
        style={{
          background:   isPremium ? 'rgba(245,197,24,0.06)' : COLORS.surface,
          borderColor:  isPremium ? 'rgba(245,197,24,0.3)'  : COLORS.border,
        }}
      >
        <div className="flex items-center justify-between">
          <p className="font-black text-lg" style={{ color: isPremium ? COLORS.gold : COLORS.textPrimary }}>
            {isPremium ? '⭐ Premium Active' : 'Free Plan'}
          </p>
          {subscription && (
            <span
              className="text-xs font-bold px-2.5 py-1 rounded-lg border capitalize"
              style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
            >
              {subscription.plan}
            </span>
          )}
        </div>

        {subscription && (
          <div className="space-y-1 text-sm" style={{ color: COLORS.textSecondary }}>
            <p>Started: {formatDate(subscription.started_at)}</p>
            <p>Expires: {formatDate(subscription.expires_at)}</p>
            <p>Status:&nbsp;
              <span style={{ color: subscription.status === 'active' ? '#22c55e' : COLORS.error }}>
                {subscription.status}
              </span>
            </p>
          </div>
        )}
      </div>

      {/* XP Booster — premium only */}
      {isPremium && (
        <div
          className="rounded-2xl p-5 border space-y-3"
          style={{ background: COLORS.surface, borderColor: COLORS.border }}
        >
          <div>
            <p className="font-black text-lg text-white">⚡ XP Booster</p>
            <p className="text-sm mt-1" style={{ color: COLORS.textSecondary }}>
              Earn 2× XP for 24 hours. One activation per day.
            </p>
          </div>
          <p className="text-sm font-semibold" style={{ color: boosterActive ? '#22c55e' : COLORS.textMuted }}>
            {boosterLabel(boosterExpiry)}
          </p>
          <button
            onClick={handleBooster}
            disabled={boosting || boosterActive}
            className="w-full rounded-xl py-3 font-bold transition-opacity disabled:opacity-40"
            style={{ background: COLORS.gold, color: '#000' }}
          >
            {boosting ? 'Activating…' : boosterActive ? 'Already Active' : 'Activate 2× XP (24h)'}
          </button>
        </div>
      )}

      {/* What's included */}
      <div
        className="rounded-2xl p-5 border space-y-3"
        style={{ background: COLORS.surface, borderColor: COLORS.border }}
      >
        <p className="font-black text-white">What's included</p>
        <ul className="space-y-2 text-sm" style={{ color: COLORS.textSecondary }}>
          {[
            'Unlock all 7 categories per league',
            '2× XP Booster (24h, once per day)',
            'Streak shield — protect your daily streak',
            'Priority matchmaking in Head-to-Head',
            'Exclusive Premium badge on leaderboard',
          ].map((f) => (
            <li key={f} className="flex items-center gap-2">
              <span style={{ color: COLORS.gold }}>✓</span> {f}
            </li>
          ))}
        </ul>
      </div>

      {/* Upgrade plans */}
      {!isPremium && (
        <div
          className="rounded-2xl p-5 border space-y-4"
          style={{ background: 'rgba(245,197,24,0.06)', borderColor: 'rgba(245,197,24,0.25)' }}
        >
          <p className="font-black text-lg" style={{ color: COLORS.gold }}>Choose a plan</p>
          <div className="space-y-2.5">
            <button
              onClick={() => handleUpgrade('monthly')}
              disabled={upgrading}
              className="w-full rounded-xl py-3.5 font-bold border transition-opacity disabled:opacity-50"
              style={{ color: COLORS.gold, borderColor: COLORS.gold }}
            >
              ₦2,000 / month
            </button>
            <button
              onClick={() => handleUpgrade('yearly')}
              disabled={upgrading}
              className="w-full rounded-xl py-3.5 font-bold text-black transition-opacity disabled:opacity-50"
              style={{ background: COLORS.gold }}
            >
              {upgrading ? 'Redirecting to payment…' : '₦18,000 / year · Save 25%'}
            </button>
          </div>
          <p className="text-xs text-center" style={{ color: COLORS.textMuted }}>
            Secure payment via Paystack · Cancel anytime
          </p>
        </div>
      )}

      <button
        onClick={() => router.back()}
        className="w-full rounded-2xl py-3 font-semibold border"
        style={{ color: COLORS.textMuted, borderColor: COLORS.border }}
      >
        Back
      </button>
    </div>
  )
}
