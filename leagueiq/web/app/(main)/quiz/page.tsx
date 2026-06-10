'use client'

import { useState, useRef, useCallback, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { COLORS, LEAGUE_COLORS } from '@/lib/colors'
import { submitAnswer, endSession } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'

type AnswerState = 'idle' | 'correct' | 'wrong'

export default function QuizPage() {
  const router = useRouter()
  const {
    session, questions, currentIndex, pending,
    pushAnswer, nextQuestion, setEndResult,
  } = useGameStore()

  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [fact,         setFact]         = useState<string | null>(null)
  const [showFact,     setShowFact]     = useState(false)
  const [submitting,   setSubmitting]   = useState(false)
  const [timeLeft,     setTimeLeft]     = useState(0)
  const [timerRunning, setTimerRunning] = useState(false)
  const [correctCount, setCorrectCount] = useState(0)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const intervalRef     = useRef<ReturnType<typeof setInterval> | null>(null)

  const accentColor  = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold
  const isSpeedRound = session?.mode === 'speed_round'
  const totalMs      = isSpeedRound ? 8000 : 15000
  const question     = questions[currentIndex]

  // Redirect if store is empty
  useEffect(() => {
    if (!session || !questions.length) router.replace('/play')
  }, [])

  // Start timer per question
  useEffect(() => {
    if (!question) return
    setTimeLeft(totalMs)
    setTimerRunning(true)
    questionStartMs.current = Date.now()

    intervalRef.current = setInterval(() => {
      setTimeLeft((t) => {
        if (t <= 100) {
          clearInterval(intervalRef.current!)
          return 0
        }
        return t - 100
      })
    }, 100)

    return () => clearInterval(intervalRef.current!)
  }, [currentIndex])

  // Auto-expire when timer hits 0
  useEffect(() => {
    if (timeLeft === 0 && timerRunning && !submitting) {
      handleAnswer(null)
    }
  }, [timeLeft])

  const handleAnswer = useCallback(async (selectedIndex: number | null) => {
    if (submitting || !session || !question) return
    setSubmitting(true)
    setTimerRunning(false)
    clearInterval(intervalRef.current!)

    const timeTaken = Date.now() - questionStartMs.current

    try {
      const result = await submitAnswer({
        session_id:      session.id,
        question_id:     question.id,
        selected_answer: selectedIndex as 0 | 1 | 2 | 3 | null,
        time_taken_ms:   timeTaken,
      })

      pushAnswer(result)
      if (result.is_correct) setCorrectCount((c) => c + 1)

      const newStates: AnswerState[] = [0, 1, 2, 3].map((i) => {
        if (i === result.correct_answer) return 'correct'
        if (i === selectedIndex && !result.is_correct) return 'wrong'
        return 'idle'
      })
      setAnswerStates(newStates)

      if (result.fact) { setFact(result.fact); setShowFact(true) }

      const delay = result.fact ? 2800 : 1400
      timeoutRef.current = setTimeout(async () => {
        setShowFact(false)
        setFact(null)
        setAnswerStates(['idle', 'idle', 'idle', 'idle'])

        const isLast = currentIndex === questions.length - 1
        if (isLast) {
          try {
            const endResult = await endSession(session.id)
            setEndResult(endResult)
          } catch { /* still navigate */ }
          router.replace('/results')
        } else {
          nextQuestion()
          setSubmitting(false)
        }
      }, delay)

    } catch {
      setSubmitting(false)
      setTimerRunning(true)
    }
  }, [submitting, session, question, currentIndex, questions.length])

  useEffect(() => () => {
    clearInterval(intervalRef.current!)
    if (timeoutRef.current) clearTimeout(timeoutRef.current)
  }, [])

  if (!question) return null

  const timerPct = (timeLeft / totalMs) * 100
  const timerColor = timerPct > 50 ? accentColor : timerPct > 25 ? '#F5A623' : COLORS.error

  return (
    <div className="max-w-2xl mx-auto px-4 py-4 flex flex-col gap-4">

      {/* Timer bar */}
      <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
        <div
          className="h-full rounded-full transition-none"
          style={{ width: `${timerPct}%`, background: timerColor }}
        />
      </div>

      {/* Progress + score */}
      <div className="flex justify-between items-center text-sm">
        <span style={{ color: COLORS.textMuted }}>{currentIndex + 1} / {questions.length}</span>
        <span className="font-bold" style={{ color: accentColor }}>{correctCount} correct</span>
      </div>

      {/* Question */}
      <div
        className="rounded-2xl p-5 border"
        style={{ background: COLORS.surface, borderColor: COLORS.border, minHeight: 120 }}
      >
        <p className="text-xs font-bold uppercase tracking-wider mb-2" style={{ color: COLORS.textMuted }}>
          {question.difficulty}
        </p>
        <p className="text-xl font-bold text-white leading-snug">{question.question}</p>
      </div>

      {/* Answers */}
      <div className="space-y-2.5">
        {question.options.map((opt, i) => {
          const state = answerStates[i]
          let bg: string     = COLORS.surface
          let border: string = COLORS.border
          let color: string  = COLORS.textPrimary

          if (state === 'correct') { bg = 'rgba(34,197,94,0.15)'; border = COLORS.success; color = COLORS.success }
          if (state === 'wrong')   { bg = 'rgba(239,68,68,0.15)'; border = COLORS.error;   color = COLORS.error   }

          return (
            <button
              key={i}
              onClick={() => !submitting && handleAnswer(i)}
              disabled={submitting}
              className="w-full rounded-2xl p-4 flex items-center gap-3 border text-left transition-all hover:opacity-80 active:scale-[0.99]"
              style={{ background: bg, borderColor: border, cursor: submitting ? 'not-allowed' : 'pointer' }}
            >
              <span
                className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold flex-shrink-0"
                style={{ background: state === 'idle' ? 'rgba(255,255,255,0.08)' : border + '30', color }}
              >
                {String.fromCharCode(65 + i)}
              </span>
              <span className="font-medium" style={{ color }}>{opt}</span>
            </button>
          )
        })}
      </div>

      {/* Did You Know fact */}
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
