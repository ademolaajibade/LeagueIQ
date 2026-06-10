'use client'

import { useState, useRef, useCallback, useEffect } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { COLORS } from '@/lib/colors'
import { acceptChallenge, submitAnswer, endSession } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'
import type { GameSession, Question } from '@/types'

type AnswerState = 'idle' | 'correct' | 'wrong'

export default function ChallengePage() {
  const { token } = useParams<{ token: string }>()
  const router    = useRouter()
  const { setEndResult } = useGameStore()

  const [phase,        setPhase]        = useState<'loading' | 'accepting' | 'quiz' | 'done'>('loading')
  const [session,      setSession]      = useState<GameSession | null>(null)
  const [questions,    setQuestions]    = useState<Omit<Question, 'correct_answer'>[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [fact,         setFact]         = useState<string | null>(null)
  const [showFact,     setShowFact]     = useState(false)
  const [submitting,   setSubmitting]   = useState(false)
  const [timeLeft,     setTimeLeft]     = useState(15000)
  const [correctCount, setCorrectCount] = useState(0)
  const [error,        setError]        = useState<string | null>(null)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const intervalRef     = useRef<ReturnType<typeof setInterval> | null>(null)

  useEffect(() => { setPhase('accepting') }, [token])

  async function handleAccept() {
    setPhase('loading')
    setError(null)
    try {
      const res = await acceptChallenge(token)
      setSession(res.session)
      setQuestions(res.questions)
      setPhase('quiz')
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not load challenge')
      setPhase('accepting')
    }
  }

  // Timer per question during quiz
  useEffect(() => {
    if (phase !== 'quiz' || !questions[currentIndex]) return
    setTimeLeft(15000)
    questionStartMs.current = Date.now()

    intervalRef.current = setInterval(() => {
      setTimeLeft((t) => {
        if (t <= 100) { clearInterval(intervalRef.current!); return 0 }
        return t - 100
      })
    }, 100)
    return () => clearInterval(intervalRef.current!)
  }, [currentIndex, phase])

  useEffect(() => {
    if (timeLeft === 0 && phase === 'quiz' && !submitting) handleAnswer(null)
  }, [timeLeft])

  const handleAnswer = useCallback(async (selectedIndex: number | null) => {
    if (submitting || !session || !questions[currentIndex]) return
    setSubmitting(true)
    clearInterval(intervalRef.current!)
    const timeTaken = Date.now() - questionStartMs.current

    try {
      const result = await submitAnswer({
        session_id:      session.id,
        question_id:     questions[currentIndex].id,
        selected_answer: selectedIndex as 0 | 1 | 2 | 3 | null,
        time_taken_ms:   timeTaken,
      })

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
          setCurrentIndex((i) => i + 1)
          setSubmitting(false)
        }
      }, delay)

    } catch {
      setSubmitting(false)
    }
  }, [submitting, session, questions, currentIndex])

  useEffect(() => () => {
    clearInterval(intervalRef.current!)
    if (timeoutRef.current) clearTimeout(timeoutRef.current)
  }, [])

  // Accept screen
  if (phase === 'accepting') {
    return (
      <div className="max-w-md mx-auto px-4 py-16 flex flex-col items-center gap-6 text-center">
        <span className="text-6xl">🤝</span>
        <h1 className="text-3xl font-black text-white">Friend Challenge</h1>
        <p className="text-sm leading-relaxed" style={{ color: COLORS.textMuted }}>
          A friend has challenged you! Answer the same set of questions and see who scores higher.
        </p>
        {error && (
          <p className="text-sm" style={{ color: COLORS.error }}>{error}</p>
        )}
        <button
          onClick={handleAccept}
          className="w-full max-w-xs rounded-2xl py-4 font-bold text-black"
          style={{ background: COLORS.gold }}
        >
          Accept Challenge
        </button>
        <button
          onClick={() => router.push('/home')}
          className="text-sm"
          style={{ color: COLORS.textMuted }}
        >
          Decline
        </button>
      </div>
    )
  }

  if (phase === 'loading') {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  const question   = questions[currentIndex]
  const timerPct   = (timeLeft / 15000) * 100
  const timerColor = timerPct > 50 ? COLORS.gold : timerPct > 25 ? '#F5A623' : COLORS.error

  if (!question) return null

  return (
    <div className="max-w-2xl mx-auto px-4 py-4 flex flex-col gap-4">

      {/* Challenge banner */}
      <div
        className="text-center text-sm font-semibold py-2 rounded-xl"
        style={{ background: 'rgba(245,197,24,0.1)', color: COLORS.gold, border: '1px solid rgba(245,197,24,0.2)' }}
      >
        🤝 Friend Challenge
      </div>

      {/* Timer */}
      <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
        <div className="h-full rounded-full" style={{ width: `${timerPct}%`, background: timerColor }} />
      </div>

      {/* Progress + score */}
      <div className="flex justify-between text-sm">
        <span style={{ color: COLORS.textMuted }}>{currentIndex + 1} / {questions.length}</span>
        <span className="font-bold" style={{ color: COLORS.gold }}>{correctCount} correct</span>
      </div>

      {/* Question */}
      <div className="rounded-2xl p-5 border" style={{ background: COLORS.surface, borderColor: COLORS.border, minHeight: 120 }}>
        <p className="text-xs font-bold uppercase tracking-wider mb-2" style={{ color: COLORS.textMuted }}>{question.difficulty}</p>
        <p className="text-xl font-bold text-white leading-snug">{question.question}</p>
      </div>

      {/* Answers */}
      <div className="space-y-2.5">
        {question.options.map((opt, i) => {
          const state = answerStates[i]
          let bg: string = COLORS.surface, border: string = COLORS.border, color: string = COLORS.textPrimary
          if (state === 'correct') { bg = 'rgba(34,197,94,0.15)'; border = COLORS.success; color = COLORS.success }
          if (state === 'wrong')   { bg = 'rgba(239,68,68,0.15)'; border = COLORS.error;   color = COLORS.error   }

          return (
            <button
              key={i}
              onClick={() => !submitting && handleAnswer(i)}
              disabled={submitting}
              className="w-full rounded-2xl p-4 flex items-center gap-3 border text-left transition-all hover:opacity-80"
              style={{ background: bg, borderColor: border, cursor: submitting ? 'not-allowed' : 'pointer' }}
            >
              <span className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold flex-shrink-0"
                style={{ background: 'rgba(255,255,255,0.08)', color }}>
                {String.fromCharCode(65 + i)}
              </span>
              <span className="font-medium" style={{ color }}>{opt}</span>
            </button>
          )
        })}
      </div>

      {/* Fact */}
      {showFact && fact && (
        <div className="rounded-2xl p-4 border" style={{ background: COLORS.surfaceAlt, borderColor: COLORS.gold + '40' }}>
          <p className="text-xs font-bold uppercase tracking-wider mb-2" style={{ color: COLORS.gold }}>Did You Know?</p>
          <p className="text-sm leading-relaxed" style={{ color: COLORS.textSecondary }}>{fact}</p>
        </div>
      )}

    </div>
  )
}
