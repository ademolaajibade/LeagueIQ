'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { COLORS, LEAGUE_GRADIENTS, LEAGUE_NAMES } from '@/lib/colors'
import {
  fetchLeagues, fetchCategories,
  startSession, getDailyChallenge, startSurvival as apiStartSurvival,
} from '@/lib/api'
import { useGameStore } from '@/store/gameStore'
import type { League, Category, GameMode } from '@/types'

type Step = 'league' | 'mode' | 'category'

const MODES = [
  { mode: 'quick_play'      as GameMode, label: 'Quick Play',      icon: '⚡', desc: '10 questions, pick your category',     needsCategory: true  },
  { mode: 'daily_challenge' as GameMode, label: 'Daily Challenge', icon: '📅', desc: 'One per league, resets at midnight',   needsCategory: false },
  { mode: 'speed_round'     as GameMode, label: 'Speed Round',     icon: '⏱',  desc: '20 questions, 8 seconds each',        needsCategory: false },
  { mode: 'category_blitz'  as GameMode, label: 'Category Blitz',  icon: '🌍', desc: 'Random mix from all 5 leagues',       needsCategory: false },
  { mode: 'survival'        as const,    label: 'Survival Mode',   icon: '❤️', desc: 'One wrong answer ends everything',    needsCategory: false },
  { mode: 'h2h'             as const,    label: 'Head-to-Head',    icon: '🆚', desc: 'Live 1v1 match vs another player',    needsCategory: false },
]

const FREE_CATEGORY_LIMIT = 3

export default function PlayPage() {
  const router = useRouter()
  const { setPending, setSession, startSurvival: storeStartSurvival } = useGameStore()

  const [step,           setStep]           = useState<Step>('league')
  const [leagues,        setLeagues]        = useState<League[]>([])
  const [categories,     setCategories]     = useState<Category[]>([])
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null)
  const [selectedMode,   setSelectedMode]   = useState<typeof MODES[0] | null>(null)
  const [isPremium,      setIsPremium]      = useState(false)
  const [loading,        setLoading]        = useState(true)
  const [starting,       setStarting]       = useState(false)
  const [error,          setError]          = useState<string | null>(null)

  useEffect(() => {
    async function init() {
      const { createClient } = await import('@/lib/supabase/client')
      const supabase = createClient()
      const { data: { user } } = await supabase.auth.getUser()
      if (user) {
        const { data: p } = await supabase.from('profiles').select('is_premium').eq('id', user.id).single()
        setIsPremium(p?.is_premium ?? false)
      }
      const ls = await fetchLeagues()
      setLeagues(ls)
      setLoading(false)
    }
    init()
  }, [])

  async function handleLeagueSelect(league: League) {
    setSelectedLeague(league)
    setStep('mode')
  }

  async function handleModeSelect(modeItem: typeof MODES[0]) {
    setSelectedMode(modeItem)
    if (modeItem.mode === 'h2h') {
      setPending({ league: selectedLeague!, mode: 'h2h', category: null })
      router.push('/match/lobby')
      return
    }
    if (!modeItem.needsCategory) {
      await launchGame(modeItem, null)
      return
    }
    setLoading(true)
    const cats = await fetchCategories(selectedLeague!.id).finally(() => setLoading(false))
    setCategories(cats)
    setStep('category')
  }

  async function handleCategorySelect(category: Category) {
    await launchGame(selectedMode!, category)
  }

  async function launchGame(modeItem: typeof MODES[0], category: Category | null) {
    if (!selectedLeague) return
    setStarting(true)
    setError(null)
    try {
      if (modeItem.mode === 'survival') {
        const res = await apiStartSurvival({ league_id: selectedLeague.id })
        storeStartSurvival(res.session_id, res.question, selectedLeague.id)
        router.push('/survival')
        return
      }
      const gameMode = modeItem.mode as GameMode
      const res = gameMode === 'daily_challenge'
        ? await getDailyChallenge(selectedLeague.id)
        : await startSession({ league_id: selectedLeague.id, category_id: category?.id, mode: gameMode })

      setSession(res.session, res.questions)
      setPending({ league: selectedLeague, mode: gameMode, category })
      router.push('/quiz')
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not start game')
    } finally {
      setStarting(false)
    }
  }

  function goBack() {
    if (step === 'mode')     setStep('league')
    if (step === 'category') setStep('mode')
  }

  const stepTitle = step === 'league' ? 'Pick a League' : step === 'mode' ? 'Game Mode' : 'Pick Category'

  if (loading && leagues.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-6">

      {/* Header */}
      <div className="mb-6">
        {step !== 'league' && (
          <button onClick={goBack} className="text-sm mb-2 transition-opacity hover:opacity-70" style={{ color: COLORS.textSecondary }}>
            ← Back
          </button>
        )}
        <h1 className="text-3xl font-black tracking-tight text-white">{stepTitle}</h1>
        {selectedLeague && step !== 'league' && (
          <p className="text-sm mt-1" style={{ color: COLORS.textMuted }}>
            {LEAGUE_NAMES[selectedLeague.slug]}
          </p>
        )}
      </div>

      {error && (
        <div className="mb-4 p-3 rounded-xl text-sm" style={{ background: 'rgba(239,68,68,0.1)', color: COLORS.error, border: '1px solid rgba(239,68,68,0.2)' }}>
          {error}
        </div>
      )}

      {/* Starting overlay */}
      {starting && (
        <div className="fixed inset-0 z-50 flex flex-col items-center justify-center gap-4" style={{ background: 'rgba(8,11,20,0.85)' }}>
          <div className="w-10 h-10 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
          <p className="text-sm" style={{ color: COLORS.textSecondary }}>Starting…</p>
        </div>
      )}

      {/* Step 1: League picker */}
      {step === 'league' && (
        <div className="space-y-3">
          {leagues.map((league) => {
            const [from, to] = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
            return (
              <button
                key={league.id}
                onClick={() => handleLeagueSelect(league)}
                className="w-full rounded-2xl p-5 flex items-center justify-between transition-opacity hover:opacity-90"
                style={{ background: `linear-gradient(135deg, ${from}, ${to})` }}
              >
                <span className="text-white font-extrabold text-lg">{LEAGUE_NAMES[league.slug] ?? league.name}</span>
                <span className="text-white/70 text-2xl">›</span>
              </button>
            )
          })}
        </div>
      )}

      {/* Step 2: Mode picker */}
      {step === 'mode' && (
        <div className="space-y-2.5">
          {MODES.map((m) => (
            <button
              key={m.mode}
              onClick={() => handleModeSelect(m)}
              className="w-full rounded-2xl p-4 flex items-center gap-4 border transition-opacity hover:opacity-80 text-left"
              style={{ background: COLORS.surface, borderColor: COLORS.border }}
            >
              <span className="text-3xl w-10 text-center">{m.icon}</span>
              <div className="flex-1">
                <p className="font-bold text-white">{m.label}</p>
                <p className="text-sm mt-0.5" style={{ color: COLORS.textMuted }}>{m.desc}</p>
              </div>
              <span className="text-xl" style={{ color: COLORS.textMuted }}>›</span>
            </button>
          ))}
        </div>
      )}

      {/* Step 3: Category picker */}
      {step === 'category' && (
        <div className="space-y-2.5">
          {categories.map((cat, i) => {
            const locked = !isPremium && i >= FREE_CATEGORY_LIMIT
            return (
              <button
                key={cat.id}
                onClick={() => !locked && handleCategorySelect(cat)}
                disabled={locked}
                className="w-full rounded-2xl p-4 flex items-center justify-between border transition-opacity text-left"
                style={{
                  background:   COLORS.surface,
                  borderColor:  COLORS.border,
                  opacity:      locked ? 0.5 : 1,
                  cursor:       locked ? 'not-allowed' : 'pointer',
                }}
              >
                <span className="font-semibold text-white">{cat.name}</span>
                {locked && (
                  <span
                    className="text-xs font-bold px-2.5 py-1 rounded-lg border"
                    style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
                  >
                    Premium
                  </span>
                )}
              </button>
            )
          })}
        </div>
      )}

    </div>
  )
}
