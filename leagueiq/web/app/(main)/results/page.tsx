'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { COLORS, LEAGUE_COLORS, LEVEL_COLORS } from '@/lib/colors'
import { useGameStore } from '@/store/gameStore'

export default function ResultsPage() {
  const router = useRouter()
  const { endResult, pending, questions, answers, reset } = useGameStore()

  const [xpDisplay,    setXpDisplay]    = useState(0)
  const [showLevelUp,  setShowLevelUp]  = useState(false)

  const accentColor  = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold
  const correctCount = answers.filter((a) => a.is_correct).length
  const total        = questions.length || 10
  const pct          = Math.round((correctCount / total) * 100)
  const xpEarned     = endResult?.xp_earned ?? 0

  useEffect(() => {
    if (xpEarned === 0) return
    const start = Date.now()
    const duration = 1200
    const tick = () => {
      const elapsed = Date.now() - start
      const progress = Math.min(elapsed / duration, 1)
      setXpDisplay(Math.round(xpEarned * progress))
      if (progress < 1) requestAnimationFrame(tick)
    }
    requestAnimationFrame(tick)

    if (endResult?.level_up) {
      setTimeout(() => setShowLevelUp(true), 1000)
    }
  }, [xpEarned])

  function goHome() { reset(); router.replace('/home') }
  function playAgain() { reset(); router.replace('/play') }

  const levelUpColor = LEVEL_COLORS[endResult?.level_up ?? ''] ?? COLORS.gold

  return (
    <div className="max-w-2xl mx-auto px-4 py-8 flex flex-col items-center gap-6">

      {/* Level-up modal */}
      {showLevelUp && endResult?.level_up && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-8" style={{ background: 'rgba(8,11,20,0.92)' }}>
          <div
            className="w-full max-w-sm rounded-3xl p-8 flex flex-col items-center gap-4 border"
            style={{ background: COLORS.surface, borderColor: COLORS.gold }}
          >
            <span className="text-6xl">🎉</span>
            <h2 className="text-3xl font-black text-white">Level Up!</h2>
            <p className="text-sm" style={{ color: COLORS.textMuted }}>You reached</p>
            <div
              className="px-4 py-2 rounded-xl font-bold text-lg border"
              style={{ color: levelUpColor, borderColor: levelUpColor + '40', background: levelUpColor + '15' }}
            >
              {endResult.level_up}
            </div>
            <button
              onClick={() => setShowLevelUp(false)}
              className="mt-2 w-full rounded-xl py-3 font-bold text-black"
              style={{ background: COLORS.gold }}
            >
              Awesome!
            </button>
          </div>
        </div>
      )}

      {/* Score circle */}
      <div
        className="w-44 h-44 rounded-full flex flex-col items-center justify-center border-2"
        style={{ background: COLORS.surface, borderColor: accentColor + '60' }}
      >
        <span className="text-5xl font-black" style={{ color: accentColor }}>{pct}%</span>
        <span className="text-sm mt-1" style={{ color: COLORS.textMuted }}>{correctCount}/{total} correct</span>
      </div>

      {/* XP earned */}
      <div className="flex items-center gap-3">
        <span className="text-base" style={{ color: COLORS.textSecondary }}>XP Earned</span>
        <span className="text-3xl font-black" style={{ color: COLORS.gold }}>+{xpDisplay}</span>
      </div>

      {/* Streak */}
      {(endResult?.streak ?? 0) > 0 && (
        <div className="flex items-center gap-2">
          <span
            className="px-3 py-1.5 rounded-lg text-sm font-bold border"
            style={{ color: COLORS.gold, borderColor: 'rgba(245,197,24,0.3)', background: 'rgba(245,197,24,0.1)' }}
          >
            🔥 {endResult!.streak}d
          </span>
          <span className="text-sm" style={{ color: COLORS.textSecondary }}>day streak!</span>
        </div>
      )}

      {/* Leaderboard rank */}
      {endResult?.leaderboard_position != null && (
        <div
          className="flex items-center gap-3 px-6 py-3 rounded-2xl border"
          style={{ background: COLORS.surface, borderColor: COLORS.border }}
        >
          <span className="text-sm" style={{ color: COLORS.textSecondary }}>Leaderboard</span>
          <span className="text-2xl font-black" style={{ color: accentColor }}>
            #{endResult.leaderboard_position}
          </span>
        </div>
      )}

      {/* Answer breakdown */}
      <div className="w-full space-y-3">
        <p className="text-xs font-bold uppercase tracking-widest" style={{ color: COLORS.textSecondary }}>
          Breakdown
        </p>
        {questions.map((q, i) => {
          const correct = answers[i]?.is_correct
          return (
            <div key={q.id} className="flex items-start gap-3">
              <span className="text-sm font-bold mt-0.5 w-4 flex-shrink-0" style={{ color: correct ? COLORS.success : COLORS.error }}>
                {correct ? '✓' : '✗'}
              </span>
              <p className="text-sm leading-snug" style={{ color: COLORS.textSecondary }}>{q.question}</p>
            </div>
          )
        })}
      </div>

      {/* Actions */}
      <div className="w-full space-y-3 pb-4">
        <button
          onClick={playAgain}
          className="w-full rounded-2xl py-4 font-bold text-black"
          style={{ background: accentColor }}
        >
          Play Again
        </button>
        <button
          onClick={goHome}
          className="w-full rounded-2xl py-3.5 font-semibold border"
          style={{ color: COLORS.textSecondary, borderColor: COLORS.border }}
        >
          Home
        </button>
      </div>

    </div>
  )
}
