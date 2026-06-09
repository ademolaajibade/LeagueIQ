import { useState, useRef, useCallback, useEffect } from 'react'
import {
  View, Text, StyleSheet, SafeAreaView,
  ScrollView, Animated, Alert,
} from 'react-native'
import { useRouter } from 'expo-router'
import * as Haptics from 'expo-haptics'
import TimerBar from '../../components/TimerBar'
import AnswerCard from '../../components/AnswerCard'
import { COLORS, LEAGUE_COLORS } from '../../lib/colors'
import { submitAnswer, endSession } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'

type AnswerState = 'idle' | 'correct' | 'wrong' | 'revealed'

export default function QuizScreen() {
  const router = useRouter()
  const {
    session, questions, currentIndex, pending,
    pushAnswer, nextQuestion, setEndResult,
  } = useGameStore()

  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [fact, setFact] = useState<string | null>(null)
  const [showFact, setShowFact] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [timerRunning, setTimerRunning] = useState(true)

  const questionStartMs = useRef(Date.now())
  const factTimeoutRef  = useRef<ReturnType<typeof setTimeout> | null>(null)
  const scoreAnim       = useRef(new Animated.Value(0)).current

  const accentColor = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold
  const isSpeedRound = session?.mode === 'speed_round'
  const timerMs      = isSpeedRound ? 8000 : 15000
  const question     = questions[currentIndex]

  // Safety redirect if store is missing data
  useEffect(() => {
    if (!session || !questions.length) {
      router.replace('/(app)/play')
    }
  }, [])

  const handleExpire = useCallback(() => {
    if (submitting) return
    handleAnswer(null)
  }, [submitting, currentIndex])

  async function handleAnswer(selectedIndex: number | null) {
    if (submitting || !session || !question) return
    setSubmitting(true)
    setTimerRunning(false)

    const timeTaken = Date.now() - questionStartMs.current

    let newStates: AnswerState[] = ['idle', 'idle', 'idle', 'idle']

    try {
      const result = await submitAnswer({
        session_id:      session.id,
        question_id:     question.id,
        selected_answer: selectedIndex as 0 | 1 | 2 | 3 | null,
        time_taken_ms:   timeTaken,
      })

      pushAnswer(result)

      // Mark correct / wrong
      newStates = newStates.map((_, i) => {
        if (i === result.correct_answer) return 'correct'
        if (i === selectedIndex && !result.is_correct) return 'wrong'
        return 'idle'
      }) as AnswerState[]

      setAnswerStates(newStates)

      if (result.is_correct) {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success)
        Animated.sequence([
          Animated.timing(scoreAnim, { toValue: 1, duration: 200, useNativeDriver: true }),
          Animated.timing(scoreAnim, { toValue: 0, duration: 200, useNativeDriver: true }),
        ]).start()
      } else {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error)
      }

      if (result.fact) {
        setFact(result.fact)
        setShowFact(true)
      }

      // Advance after delay
      factTimeoutRef.current = setTimeout(async () => {
        setShowFact(false)
        setAnswerStates(['idle', 'idle', 'idle', 'idle'])
        setFact(null)

        const isLast = currentIndex === questions.length - 1

        if (isLast) {
          try {
            const endResult = await endSession(session.id)
            setEndResult(endResult)
            router.replace('/game/results')
          } catch {
            router.replace('/game/results')
          }
        } else {
          nextQuestion()
          questionStartMs.current = Date.now()
          setSubmitting(false)
          setTimerRunning(true)
        }
      }, showFact ? 2800 : 1400)

    } catch (e: unknown) {
      Alert.alert('Error', 'Failed to submit answer')
      setSubmitting(false)
      setTimerRunning(true)
    }
  }

  useEffect(() => {
    return () => {
      if (factTimeoutRef.current) clearTimeout(factTimeoutRef.current)
    }
  }, [])

  if (!question) return null

  const answered = submitting
  const scoreY = scoreAnim.interpolate({ inputRange: [0, 1], outputRange: [0, -8] })

  return (
    <SafeAreaView style={styles.safe}>
      {/* Timer */}
      <View style={styles.timerWrap}>
        <TimerBar
          key={currentIndex}
          durationMs={timerMs}
          running={timerRunning}
          onExpire={handleExpire}
        />
      </View>

      {/* Progress + Score */}
      <View style={styles.meta}>
        <Text style={styles.progress}>
          {currentIndex + 1} / {questions.length}
        </Text>
        <Animated.Text style={[styles.score, { color: accentColor, transform: [{ translateY: scoreY }] }]}>
          {useGameStore.getState().answers.filter((a) => a.is_correct).length} correct
        </Animated.Text>
      </View>

      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

        {/* Question */}
        <View style={styles.questionBox}>
          <Text style={styles.diffBadge}>{question.difficulty?.toUpperCase()}</Text>
          <Text style={styles.questionText}>{question.question}</Text>
        </View>

        {/* Answers */}
        <View style={styles.answers}>
          {question.options.map((opt, i) => (
            <AnswerCard
              key={i}
              index={i}
              label={opt}
              state={answerStates[i]}
              disabled={answered}
              accentColor={accentColor}
              onPress={handleAnswer}
            />
          ))}
        </View>

        {/* Did You Know fact */}
        {showFact && fact && (
          <View style={[styles.factCard, { borderColor: accentColor + '40' }]}>
            <Text style={[styles.factTitle, { color: accentColor }]}>Did You Know?</Text>
            <Text style={styles.factText}>{fact}</Text>
          </View>
        )}

      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 20, paddingBottom: 32 },

  timerWrap: { paddingHorizontal: 20, paddingTop: 12 },

  meta: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
    paddingHorizontal: 20,
    paddingVertical:   10,
  },
  progress: { color: COLORS.textMuted, fontSize: 14, fontWeight: '600' },
  score:    { fontSize: 15, fontWeight: '800' },

  questionBox: {
    backgroundColor: COLORS.surface,
    borderRadius:    16,
    padding:         20,
    marginBottom:    20,
    borderWidth:     1,
    borderColor:     COLORS.border,
    minHeight:       120,
  },
  diffBadge: {
    color:         COLORS.textMuted,
    fontSize:      10,
    fontWeight:    '700',
    letterSpacing: 1,
    marginBottom:  8,
  },
  questionText: {
    color:      COLORS.textPrimary,
    fontSize:   20,
    fontWeight: '700',
    lineHeight: 28,
  },

  answers: { gap: 0 },

  factCard: {
    backgroundColor: COLORS.surfaceAlt,
    borderRadius:    14,
    borderWidth:     1,
    padding:         16,
    marginTop:       8,
  },
  factTitle: { fontSize: 12, fontWeight: '700', letterSpacing: 0.5, marginBottom: 6 },
  factText:  { color: COLORS.textSecondary, fontSize: 14, lineHeight: 20 },
})
