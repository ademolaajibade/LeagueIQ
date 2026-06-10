'use client'

import { useState, useRef, useEffect, useCallback } from 'react'
import { useParams, useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { COLORS, LEAGUE_COLORS } from '@/lib/colors'
import { submitMatchAnswer, endMatch } from '@/lib/api'
import { useGameStore } from '@/store/gameStore'
import type { Question } from '@/types'

type AnswerState = 'idle' | 'correct' | 'wrong'

interface Match {
  id:        string
  status:    'waiting' | 'active' | 'completed'
  winner_id: string | null
  player1_id: string
  player2_id: string | null
  question_ids: string[]
}

const TIMER_MS = 15000

export default function MatchPage() {
  const { id }    = useParams<{ id: string }>()
  const router    = useRouter()
  const pending   = useGameStore((s) => s.pending)
  const supabase  = createClient()

  const [match,             setMatch]             = useState<Match | null>(null)
  const [questions,         setQuestions]         = useState<Omit<Question, 'correct_answer'>[]>([])
  const [currentIndex,      setCurrentIndex]      = useState(0)
  const [answerStates,      setAnswerStates]      = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [submitting,        setSubmitting]        = useState(false)
  const [waitingForOpp,     setWaitingForOpp]     = useState(true)
  const [opponentAnswered,  setOpponentAnswered]  = useState(false)
  const [myScore,           setMyScore]           = useState(0)
  const [opponentScore,     setOpponentScore]     = useState(0)
  const [timeLeft,          setTimeLeft]          = useState(TIMER_MS)
  const [timerRunning,      setTimerRunning]      = useState(false)
  const [joinCode,          setJoinCode]          = useState('')
  const [myUserId,          setMyUserId]          = useState<string | null>(null)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const intervalRef     = useRef<ReturnType<typeof setInterval> | null>(null)

  const accentColor = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => setMyUserId(data.user?.id ?? null))
  }, [])

  // Load match
  useEffect(() => {
    if (!id) return
    supabase
      .from('matches')
      .select('*')
      .eq('id', id)
      .single()
      .then(({ data }) => {
        if (!data) return
        const m = data as Match
        setMatch(m)
        setJoinCode(m.id.slice(0, 8).toUpperCase())
        if (m.status === 'active') {
          setWaitingForOpp(false)
          loadQuestions(m.question_ids)
        }
      })
  }, [id])

  async function loadQuestions(ids: string[]) {
    const { data } = await supabase
      .from('questions')
      .select('id, question, options, difficulty, league_id, category_id, fact, is_active, created_at')
      .in('id', ids)
    if (data) setQuestions(data as Omit<Question, 'correct_answer'>[])
  }

  // Realtime subscription
  useEffect(() => {
    if (!id) return
    const channel = supabase
      .channel(`match:${id}`)
      .on('postgres_changes', {
        event: 'UPDATE', schema: 'public', table: 'matches', filter: `id=eq.${id}`,
      }, (payload) => {
        const updated = payload.new as Match
        setMatch(updated)
        if (updated.status === 'active' && waitingForOpp) {
          setWaitingForOpp(false)
          loadQuestions(updated.question_ids)
          setTimerRunning(true)
          questionStartMs.current = Date.now()
        }
        if (updated.status === 'completed') {
          router.replace(`/match/results?match_id=${id}&winner_id=${updated.winner_id ?? ''}`)
        }
      })
      .on('postgres_changes', {
        event: 'INSERT', schema: 'public', table: 'match_answers', filter: `match_id=eq.${id}`,
      }, (payload) => {
        const ans = payload.new as { user_id: string; is_correct: boolean }
        if (ans.user_id !== myUserId) {
          setOpponentAnswered(true)
          if (ans.is_correct) setOpponentScore((s) => s + 1)
        }
      })
      .subscribe()

    return () => { supabase.removeChannel(channel) }
  }, [id, myUserId, waitingForOpp])

  // Timer per question
  useEffect(() => {
    if (!timerRunning || waitingForOpp) return
    setTimeLeft(TIMER_MS)
    intervalRef.current = setInterval(() => {
      setTimeLeft((t) => {
        if (t <= 100) { clearInterval(intervalRef.current!); return 0 }
        return t - 100
      })
    }, 100)
    return () => clearInterval(intervalRef.current!)
  }, [currentIndex, timerRunning])

  useEffect(() => {
    if (timeLeft === 0 && timerRunning && !submitting) handleAnswer(null)
  }, [timeLeft])

  const handleAnswer = useCallback(async (selectedIndex: number | null) => {
    if (submitting || !match || !questions[currentIndex]) return
    setSubmitting(true)
    setTimerRunning(false)
    clearInterval(intervalRef.current!)

    const timeTaken = Date.now() - questionStartMs.current
    const question  = questions[currentIndex]

    try {
      const result = await submitMatchAnswer({
        match_id:        match.id,
        question_id:     question.id,
        selected_answer: selectedIndex as 0 | 1 | 2 | 3 | null,
        time_taken_ms:   timeTaken,
      })

      const newStates: AnswerState[] = [0, 1, 2, 3].map((i) => {
        if (i === result.correct_answer) return 'correct'
        if (i === selectedIndex && !result.is_correct) return 'wrong'
        return 'idle'
      })
      setAnswerStates(newStates)
      if (result.is_correct) setMyScore((s) => s + 1)

      timeoutRef.current = setTimeout(async () => {
        setAnswerStates(['idle', 'idle', 'idle', 'idle'])
        setOpponentAnswered(false)
        const isLast = currentIndex === questions.length - 1
        if (isLast) {
          await endMatch(match.id).catch(() => null)
        } else {
          setCurrentIndex((i) => i + 1)
          questionStartMs.current = Date.now()
          setSubmitting(false)
          setTimerRunning(true)
        }
      }, 1600)

    } catch {
      setSubmitting(false)
      setTimerRunning(true)
    }
  }, [submitting, match, questions, currentIndex])

  useEffect(() => () => {
    clearInterval(intervalRef.current!)
    if (timeoutRef.current) clearTimeout(timeoutRef.current)
  }, [])

  if (waitingForOpp) {
    return (
      <div className="flex flex-col items-center justify-center min-h-[60vh] gap-6 px-8">
        <span className="text-6xl">⏳</span>
        <h2 className="text-2xl font-bold text-white text-center">Waiting for opponent…</h2>
        {joinCode && (
          <div
            className="px-8 py-5 rounded-2xl border text-center"
            style={{ background: COLORS.surface, borderColor: COLORS.gold }}
          >
            <p className="text-xs font-bold uppercase tracking-widest mb-2" style={{ color: COLORS.textMuted }}>Join Code</p>
            <p className="text-4xl font-black tracking-widest" style={{ color: COLORS.gold }}>{joinCode}</p>
            <p className="text-xs mt-3" style={{ color: COLORS.textMuted }}>Share this with your opponent</p>
          </div>
        )}
      </div>
    )
  }

  const question  = questions[currentIndex]
  const timerPct  = (timeLeft / TIMER_MS) * 100
  const timerColor = timerPct > 50 ? accentColor : timerPct > 25 ? '#F5A623' : COLORS.error

  if (!question) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="w-8 h-8 border-2 border-t-transparent rounded-full animate-spin" style={{ borderColor: COLORS.gold }} />
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-4 flex flex-col gap-4">

      {/* Scores */}
      <div
        className="flex items-center justify-around py-4 rounded-2xl border"
        style={{ background: COLORS.surface, borderColor: COLORS.border }}
      >
        <div className="text-center">
          <p className="text-4xl font-black" style={{ color: accentColor }}>{myScore}</p>
          <p className="text-xs mt-1" style={{ color: COLORS.textMuted }}>You</p>
        </div>
        <p className="text-sm font-bold" style={{ color: COLORS.textMuted }}>VS</p>
        <div className="text-center">
          <p className="text-4xl font-black text-white">{opponentScore}</p>
          <p className="text-xs mt-1" style={{ color: COLORS.textMuted }}>Opponent</p>
        </div>
      </div>

      {/* Opponent answered */}
      {opponentAnswered && (
        <div
          className="text-center text-sm font-semibold py-2 rounded-xl"
          style={{ background: 'rgba(34,197,94,0.1)', color: COLORS.success, border: '1px solid rgba(34,197,94,0.2)' }}
        >
          Opponent answered ✓
        </div>
      )}

      {/* Timer */}
      <div className="h-1.5 rounded-full overflow-hidden" style={{ background: 'rgba(255,255,255,0.08)' }}>
        <div className="h-full rounded-full" style={{ width: `${timerPct}%`, background: timerColor }} />
      </div>

      <p className="text-sm" style={{ color: COLORS.textMuted }}>
        {currentIndex + 1} / {questions.length || 10}
      </p>

      {/* Question */}
      <div className="rounded-2xl p-5 border" style={{ background: COLORS.surface, borderColor: COLORS.border, minHeight: 100 }}>
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

    </div>
  )
}
