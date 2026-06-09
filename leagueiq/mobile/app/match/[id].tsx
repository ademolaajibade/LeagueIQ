import { useState, useRef, useEffect, useCallback } from 'react'
import {
  View, Text, StyleSheet, Alert,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useLocalSearchParams, useRouter } from 'expo-router'
import * as Haptics from 'expo-haptics'
import TimerBar from '../../components/TimerBar'
import AnswerCard from '../../components/AnswerCard'
import { COLORS, LEAGUE_COLORS } from '../../lib/colors'
import { submitMatchAnswer, endMatch } from '../../lib/api'
import { supabase } from '../../lib/supabase'
import { useGameStore } from '../../store/gameStore'
import { useAuth } from '../../contexts/AuthContext'
import type { Match, Question } from '../../types'

type AnswerState = 'idle' | 'correct' | 'wrong' | 'revealed'

export default function MatchScreen() {
  const { id } = useLocalSearchParams<{ id: string }>()
  const router  = useRouter()
  const { profile } = useAuth()
  const { pending } = useGameStore()

  const [match, setMatch]             = useState<Match | null>(null)
  const [questions, setQuestions]     = useState<Omit<Question, 'correct_answer'>[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [submitting, setSubmitting]   = useState(false)
  const [timerRunning, setTimerRunning] = useState(false)
  const [opponentAnswered, setOpponentAnswered] = useState(false)
  const [waitingForOpponent, setWaitingForOpponent] = useState(true)
  const [myScore, setMyScore]         = useState(0)
  const [opponentScore, setOpponentScore] = useState(0)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const accentColor     = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold

  // Load match + subscribe to Realtime
  useEffect(() => {
    if (!id) return

    supabase
      .from('matches')
      .select('*')
      .eq('id', id)
      .single()
      .then(({ data }) => {
        if (data) {
          setMatch(data as Match)
          if (data.status === 'active') {
            setWaitingForOpponent(false)
            setTimerRunning(true)
          }
        }
      })

    const channel = supabase
      .channel(`match:${id}`)
      .on('postgres_changes', {
        event:  'UPDATE',
        schema: 'public',
        table:  'matches',
        filter: `id=eq.${id}`,
      }, (payload) => {
        const updated = payload.new as Match
        setMatch(updated)
        if (updated.status === 'active' && waitingForOpponent) {
          setWaitingForOpponent(false)
          setTimerRunning(true)
          questionStartMs.current = Date.now()
        }
        if (updated.status === 'completed') {
          router.replace(`/match/results?match_id=${id}&winner_id=${updated.winner_id ?? ''}`)
        }
      })
      .on('postgres_changes', {
        event:  'INSERT',
        schema: 'public',
        table:  'match_answers',
        filter: `match_id=eq.${id}`,
      }, (payload) => {
        const ans = payload.new as { user_id: string; question_id: string; is_correct: boolean }
        if (ans.user_id !== profile?.id) {
          setOpponentAnswered(true)
          if (ans.is_correct) setOpponentScore((s) => s + 1)
        }
      })
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
      if (timeoutRef.current) clearTimeout(timeoutRef.current)
    }
  }, [id])

  const handleExpire = useCallback(() => {
    if (submitting) return
    handleAnswer(null)
  }, [submitting, currentIndex])

  async function handleAnswer(selectedIndex: number | null) {
    if (submitting || !match || !questions[currentIndex]) return
    setSubmitting(true)
    setTimerRunning(false)

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

      if (result.is_correct) {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success)
        setMyScore((s) => s + 1)
      } else {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error)
      }

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
      Alert.alert('Error', 'Failed to submit answer')
      setSubmitting(false)
      setTimerRunning(true)
    }
  }

  const question = questions[currentIndex]

  if (waitingForOpponent) {
    return (
      <SafeAreaView style={styles.safe}>
        <View style={styles.waiting}>
          <Text style={styles.waitingEmoji}>⏳</Text>
          <Text style={styles.waitingTitle}>Waiting for opponent…</Text>
          {match && (
            <View style={styles.codePill}>
              <Text style={styles.codeLabel}>Join Code</Text>
              <Text style={styles.codeValue}>{match.id.slice(0, 8).toUpperCase()}</Text>
            </View>
          )}
        </View>
      </SafeAreaView>
    )
  }

  if (!question) {
    return (
      <SafeAreaView style={styles.safe}>
        <View style={styles.waiting}>
          <Text style={styles.waitingTitle}>Loading questions…</Text>
        </View>
      </SafeAreaView>
    )
  }

  return (
    <SafeAreaView style={styles.safe}>
      {/* Scores header */}
      <View style={styles.scoresRow}>
        <View style={styles.scoreCell}>
          <Text style={[styles.scoreNum, { color: accentColor }]}>{myScore}</Text>
          <Text style={styles.scoreLabel}>You</Text>
        </View>
        <Text style={styles.vs}>VS</Text>
        <View style={styles.scoreCell}>
          <Text style={styles.scoreNum}>{opponentScore}</Text>
          <Text style={styles.scoreLabel}>Opponent</Text>
        </View>
      </View>

      {/* Opponent answered indicator */}
      {opponentAnswered && (
        <View style={styles.opponentBadge}>
          <Text style={styles.opponentBadgeText}>Opponent answered ✓</Text>
        </View>
      )}

      {/* Timer */}
      <View style={styles.timerWrap}>
        <TimerBar
          key={currentIndex}
          durationMs={15000}
          running={timerRunning}
          onExpire={handleExpire}
        />
      </View>

      {/* Progress */}
      <Text style={styles.progress}>{currentIndex + 1} / {questions.length || 10}</Text>

      <View style={styles.body}>
        {/* Question */}
        <View style={styles.questionBox}>
          <Text style={styles.questionText}>{question.question}</Text>
        </View>

        {/* Answers */}
        {question.options.map((opt, i) => (
          <AnswerCard
            key={i}
            index={i}
            label={opt}
            state={answerStates[i]}
            disabled={submitting}
            accentColor={accentColor}
            onPress={handleAnswer}
          />
        ))}
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe: { flex: 1, backgroundColor: COLORS.background },

  scoresRow: {
    flexDirection:  'row',
    justifyContent: 'space-around',
    alignItems:     'center',
    paddingVertical: 16,
    paddingHorizontal: 32,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  scoreCell: { alignItems: 'center' },
  scoreNum:  { color: COLORS.textPrimary, fontSize: 32, fontWeight: '900' },
  scoreLabel: { color: COLORS.textMuted, fontSize: 12 },
  vs:         { color: COLORS.textMuted, fontSize: 14, fontWeight: '700' },

  opponentBadge: {
    backgroundColor: 'rgba(34,197,94,0.1)',
    paddingHorizontal: 14,
    paddingVertical: 5,
    marginHorizontal: 20,
    marginTop: 8,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: 'rgba(34,197,94,0.2)',
    alignSelf: 'center',
  },
  opponentBadgeText: { color: COLORS.success, fontSize: 13, fontWeight: '600' },

  timerWrap: { paddingHorizontal: 20, paddingTop: 12 },
  progress: {
    color: COLORS.textMuted,
    fontSize: 13,
    fontWeight: '600',
    paddingHorizontal: 20,
    paddingTop: 6,
  },

  body: { flex: 1, padding: 20 },
  questionBox: {
    backgroundColor: COLORS.surface,
    borderRadius: 16,
    padding: 20,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: COLORS.border,
    minHeight: 100,
  },
  questionText: {
    color: COLORS.textPrimary,
    fontSize: 20,
    fontWeight: '700',
    lineHeight: 28,
  },

  waiting: { flex: 1, justifyContent: 'center', alignItems: 'center', gap: 16, padding: 32 },
  waitingEmoji: { fontSize: 52 },
  waitingTitle: { color: COLORS.textPrimary, fontSize: 22, fontWeight: '700', textAlign: 'center' },
  codePill: {
    backgroundColor: COLORS.surface,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: COLORS.gold,
    paddingHorizontal: 24,
    paddingVertical: 14,
    alignItems: 'center',
    marginTop: 12,
  },
  codeLabel: { color: COLORS.textMuted, fontSize: 12, marginBottom: 4 },
  codeValue: { color: COLORS.gold, fontSize: 28, fontWeight: '900', letterSpacing: 4 },
})
