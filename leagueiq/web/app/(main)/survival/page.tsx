'use client'

import { useState, useRef, useCallback, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { COLORS, LEAGUE_COLORS } from '@/lib/colors'
import { submitSurvivalAnswer } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'

type AnswerState = 'idle' | 'correct' | 'wrong'

const TIMER_MS = 8000

export default function SurvivalPage() {
  const router = useRouter()
  const {
    survivalSessionId, survivalQuestion, survivalCount,
    survivalLeagueId, setSurvivalQuestion, incrementSurvival, reset,
  } = useGameStore()

  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [fact,         setFact]         = useState<string | null>(null)
  const [showFact,     setShowFact]     = useState(false)
  const [submitting,   setSubmitting]   = useState(false)
  const [timeLeft,     setTimeLeft]     = useState(TIMER_MS)
  const [timerRunning, setTimerRunning] = useState(false)
  const [dead,         setDead]         = useState(false)
  const [timerKey,     setTimerKey]     = useState(0)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const intervalRef     = useRef<ReturnType<typeof setInterval> | null>(null)

  const accentColor = LEAGUE_COLORS[survivalLeagueId ?? ''] ?? COLORS.error

  useEffect(() => {
    if (!survivalSessionId || !survivalQuestion) router.replace('/play')
  }, [])

  // Start timer per question
  useEffect(() => {
    if (!survivalQuestion || dead) return
    setTimeLeft(TIMER_MS)
    setTimerRunning(true)
    questionStartMs.current = Date.now()

    intervalRef.current = setInterval(() => {
      setTimeLeft((t) => {
        if (t <= 100) { clearInterval(intervalRef.current!); return 0 }
        return t - 100
      })
    }, 100)

    return () => clearInterval(intervalRef.current!)
  }, [timerKey])

  useEffect(() => {
    if (timeLeft === 0 && timerRunning && !submitting && !dead) handleAnswer(null)
  }, [timeLeft])

  useEffect(() => () => {
    clearInterval(intervalRef.current!)
    if (timeoutRef.current) clearTimeout(timeoutRef.current)
  }, [])

  const handleAnswer = useCallback(async (selectedIndex: number | null) => {
    if (submitting || !survivalSessionId || !survivalQuestion) return
    setSubmitting(true)
    setTimerRunning(false)
    clearInterval(intervalRef.current!)
    const timeTaken = Date.now() - questionStartMs.current

    try {
      const result = await submitSurvivalAnswer({
        session_id:      survivalSessionId,
        question_id:     survivalQuestion.id,
        selected_answer: selectedIndex as 0 | 1 | 2 | 3 | null,
        time_taken_ms:   timeTaken,
      })

      const newStates: AnswerState[] = [0, 1, 2, 3].map((i) => {
        if (i === result.correct_answer) return 'correct'
        if (i === selectedIndex && !result.is_correct) return 'wrong'
        return 'idle'
      })
      setAnswerStates(newStates)
      if (result.is_correct) incrementSurvival()

      if (result.fact) { setFact(result.fact); setShowFact(true) }

      const delay = result.fact ? 2800 : 1200
      timeoutRef.current = setTimeout(() => {
        setShowFact(false)
        setFact(null)
        setAnswerStates(['idle', 'idle', 'idle', 'idle'])

        if (!result.is_correct || result.next_question === null) {
          setDead(true)
        } else {
          setSurvivalQuestion(result.next_question)
          setTimerKey((k) => k + 1)
          setSubmitting(false)
        }
      }, delay)

    } catch {
      setSubmitting(false)
      setTimerRunning(true)
    }
  }, [submitting, survivalSessionId, survivalQuestion])

  function handleDone() {
    reset()
    router.replace('/home')
  }

  if (dead) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[70vh] px-8 gap-4">
        <div className="text-6xl mb-2">💀</div>
        <h1 className="text-4xl font-black text-white">Game Over</h1>
        <p className="text-base" style={{ color: COLORS.textMuted }}>You survived</p>
        <p className="text-8xl font-black leading-none" style={{ color: accentColor }}>{survivalCount}</p>
        <p className="text-lg" style={{ color: COLORS.textMuted }}>questions</p>
        <div className="w-full max-w-xs mt-6 space-y-3">
          <button
            onClick={() => { reset(); router.push('/leaderboard') }}
            className="w-full rounded-2xl py-4 font-bold text-white"
            style={{ background: accentColor }}
          >
            See Leaderboard
          </button>
          <button
            onClick={handleDone}
            className="w-full rounded-2xl py-3.5 font-semibold border"
            style={{ color: COLORS.textMuted, borderColor: COLORS.border }}
          >
            Home
          </button>
        </div>
      </div>
    )
  }

  if (!survivalQuestion) return null

  const timerPct   = (timeLeft / TIMER_MS) * 100
  const timerColor = timerPct > 50 ? accentColor : timerPct > 25 ? '#F5A623' : COLORS.error

  return (
    <div className="max-w-2xl mx-auto px-4 py-4 flex flex-col gap-4">

      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <span className="text-2xl">❤️</span>
          <span className="font-bold text-sm" style={{ color: COLORS.error }}>1 life</span>
        </div>
        <div className="text-center">
          <p className="text-4xl font-black leading-none" style={{ color: accentColor }}>{survivalCount}</p>
          <p className="text-xs mt-0.5" style={{ color: COLORS.textMuted }}>survived</p>
        </div>
      </div>

      {/* Timer bar */}
      <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
        <div
          className="h-full rounded-full transition-none"
          style={{ width: `${timerPct}%`, background: timerColor }}
        />
      </div>

      {/* Question */}
      <div
        className="rounded-2xl p-5 border"
        style={{ background: COLORS.surface, borderColor: COLORS.border, minHeight: 100 }}
      >
        <p className="text-xl font-bold text-white leading-snug">{survivalQuestion.question}</p>
      </div>

      {/* Answers */}
      <div className="space-y-2.5">
        {survivalQuestion.options.map((opt, i) => {
          const state = answerStates[i]
          let bg: string     = COLORS.surface
          let border: string = COLORS.border
          let color: string  = COLORS.textPrimary

          if (state === 'correct') { bg = 'rgba(34,197,94,0.15)'; border = COLORS.success; color = COLORS.success }
          if (state === 'wrong')   { bg = 'rgba(239,68,68,0.15)'; border = COLORS.error;   color = COLORS.error   }

          return (
            <button
              key={`${survivalQuestion.id}-${i}`}
              onClick={() => !submitting && handleAnswer(i)}
              disabled={submitting}
              className="w-full rounded-2xl p-4 flex items-center gap-3 border text-left transition-all hover:opacity-80"
              style={{ background: bg, borderColor: border, cursor: submitting ? 'not-allowed' : 'pointer' }}
            >
              <span
                className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold flex-shrink-0"
                style={{ background: 'rgba(255,255,255,0.08)', color }}
              >
                {String.fromCharCode(65 + i)}
              </span>
              <span className="font-medium" style={{ color }}>{opt}</span>
            </button>
          )
        })}
      </div>

      {/* Fact */}
      {showFact && fact && (
        <div
          className="rounded-2xl p-4 border"
          style={{ background: COLORS.surfaceAlt, borderColor: accentColor + '40' }}
        >
          <p className="text-xs font-bold uppercase tracking-wider mb-2" style={{ color: accentColor }}>
            Did You Know?
          </p>
          <p className="text-sm leading-relaxed" style={{ color: COLORS.textSecondary }}>{fact}</p>
        </div>
      )}

    </div>
  )
}
