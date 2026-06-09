import { useState, useRef, useCallback, useEffect } from 'react'
import {
  View, Text, StyleSheet, TouchableOpacity, Alert,
  Animated,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import * as Haptics from 'expo-haptics'
import TimerBar from '../../components/TimerBar'
import AnswerCard from '../../components/AnswerCard'
import { COLORS, LEAGUE_COLORS } from '../../lib/colors'
import { submitSurvivalAnswer } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'

type AnswerState = 'idle' | 'correct' | 'wrong' | 'revealed'

export default function SurvivalScreen() {
  const router = useRouter()
  const {
    survivalSessionId, survivalQuestion, survivalCount,
    survivalLeagueId, setSurvivalQuestion, incrementSurvival, reset,
  } = useGameStore()

  const [answerStates, setAnswerStates] = useState<AnswerState[]>(['idle', 'idle', 'idle', 'idle'])
  const [fact, setFact] = useState<string | null>(null)
  const [showFact, setShowFact] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [timerRunning, setTimerRunning] = useState(true)
  const [dead, setDead] = useState(false)
  const [timerKey, setTimerKey] = useState(0)

  const questionStartMs = useRef(Date.now())
  const timeoutRef      = useRef<ReturnType<typeof setTimeout> | null>(null)
  const deathAnim       = useRef(new Animated.Value(0)).current

  const accentColor = LEAGUE_COLORS[survivalLeagueId ?? ''] ?? COLORS.error

  useEffect(() => {
    if (!survivalSessionId || !survivalQuestion) {
      router.replace('/(app)/play')
    }
  }, [])

  useEffect(() => {
    return () => { if (timeoutRef.current) clearTimeout(timeoutRef.current) }
  }, [])

  const handleExpire = useCallback(() => {
    if (submitting) return
    handleAnswer(null)
  }, [submitting])

  async function handleAnswer(selectedIndex: number | null) {
    if (submitting || !survivalSessionId || !survivalQuestion) return
    setSubmitting(true)
    setTimerRunning(false)
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

      if (result.is_correct) {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success)
        incrementSurvival()
      } else {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error)
      }

      if (result.fact) { setFact(result.fact); setShowFact(true) }

      timeoutRef.current = setTimeout(() => {
        setShowFact(false)
        setFact(null)
        setAnswerStates(['idle', 'idle', 'idle', 'idle'])

        if (result.next_question === null || !result.is_correct) {
          // Game over
          Animated.timing(deathAnim, { toValue: 1, duration: 600, useNativeDriver: true }).start()
          setDead(true)
        } else {
          setSurvivalQuestion(result.next_question)
          setTimerKey((k) => k + 1)
          questionStartMs.current = Date.now()
          setSubmitting(false)
          setTimerRunning(true)
        }
      }, showFact ? 2800 : 1200)

    } catch {
      Alert.alert('Error', 'Failed to submit answer')
      setSubmitting(false)
      setTimerRunning(true)
    }
  }

  function handleDone() {
    reset()
    router.replace('/(app)')
  }

  if (dead) {
    return (
      <SafeAreaView style={styles.safe}>
        <Animated.View style={[styles.deathScreen, { opacity: deathAnim }]}>
          <Text style={styles.deathEmoji}>💀</Text>
          <Text style={styles.deathTitle}>Game Over</Text>
          <Text style={styles.deathSub}>You survived</Text>
          <Text style={[styles.deathCount, { color: accentColor }]}>{survivalCount}</Text>
          <Text style={styles.deathSub2}>questions</Text>
          <TouchableOpacity style={[styles.doneBtn, { backgroundColor: accentColor }]} onPress={handleDone} activeOpacity={0.85}>
            <Text style={styles.doneBtnText}>See Leaderboard</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.homeBtn} onPress={handleDone} activeOpacity={0.7}>
            <Text style={styles.homeBtnText}>Home</Text>
          </TouchableOpacity>
        </Animated.View>
      </SafeAreaView>
    )
  }

  if (!survivalQuestion) return null

  return (
    <SafeAreaView style={styles.safe}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.heartRow}>
          <Text style={styles.heart}>❤️</Text>
          <Text style={styles.heartLabel}>1 life</Text>
        </View>
        <View style={styles.countBadge}>
          <Text style={[styles.countText, { color: accentColor }]}>{survivalCount}</Text>
          <Text style={styles.countLabel}>survived</Text>
        </View>
      </View>

      {/* Timer */}
      <View style={styles.timerWrap}>
        <TimerBar
          key={timerKey}
          durationMs={8000}
          running={timerRunning}
          onExpire={handleExpire}
        />
      </View>

      <View style={styles.body}>
        {/* Question */}
        <View style={styles.questionBox}>
          <Text style={styles.questionText}>{survivalQuestion.question}</Text>
        </View>

        {/* Answers */}
        <View>
          {survivalQuestion.options.map((opt, i) => (
            <AnswerCard
              key={`${survivalQuestion.id}-${i}`}
              index={i}
              label={opt}
              state={answerStates[i]}
              disabled={submitting}
              accentColor={accentColor}
              onPress={handleAnswer}
            />
          ))}
        </View>

        {/* Fact */}
        {showFact && fact && (
          <View style={[styles.factCard, { borderColor: accentColor + '40' }]}>
            <Text style={[styles.factTitle, { color: accentColor }]}>Did You Know?</Text>
            <Text style={styles.factText}>{fact}</Text>
          </View>
        )}
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },

  header: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
    paddingHorizontal: 20,
    paddingTop:     16,
    paddingBottom:  8,
  },
  heartRow:   { flexDirection: 'row', alignItems: 'center', gap: 6 },
  heart:      { fontSize: 22 },
  heartLabel: { color: COLORS.error, fontWeight: '700', fontSize: 14 },
  countBadge: { alignItems: 'center' },
  countText:  { fontSize: 32, fontWeight: '900' },
  countLabel: { color: COLORS.textMuted, fontSize: 12 },

  timerWrap: { paddingHorizontal: 20, marginBottom: 4 },

  body: { flex: 1, padding: 20 },

  questionBox: {
    backgroundColor: COLORS.surface,
    borderRadius:    16,
    padding:         20,
    marginBottom:    20,
    borderWidth:     1,
    borderColor:     COLORS.border,
    minHeight:       100,
  },
  questionText: {
    color:      COLORS.textPrimary,
    fontSize:   20,
    fontWeight: '700',
    lineHeight: 28,
  },

  factCard: {
    backgroundColor: COLORS.surfaceAlt,
    borderRadius:    14,
    borderWidth:     1,
    padding:         16,
    marginTop:       8,
  },
  factTitle: { fontSize: 12, fontWeight: '700', letterSpacing: 0.5, marginBottom: 6 },
  factText:  { color: COLORS.textSecondary, fontSize: 14, lineHeight: 20 },

  // Death screen
  deathScreen: {
    flex:           1,
    justifyContent: 'center',
    alignItems:     'center',
    padding:        32,
    gap:            8,
  },
  deathEmoji: { fontSize: 64, marginBottom: 8 },
  deathTitle: { color: COLORS.textPrimary, fontSize: 32, fontWeight: '900' },
  deathSub:   { color: COLORS.textMuted, fontSize: 16 },
  deathCount: { fontSize: 72, fontWeight: '900', lineHeight: 80 },
  deathSub2:  { color: COLORS.textMuted, fontSize: 18, marginBottom: 24 },
  doneBtn: {
    width:           '100%',
    borderRadius:    14,
    paddingVertical: 16,
    alignItems:      'center',
  },
  doneBtnText: { color: '#fff', fontWeight: '800', fontSize: 16 },
  homeBtn: {
    width:           '100%',
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    paddingVertical: 14,
    alignItems:      'center',
    marginTop:       4,
  },
  homeBtnText: { color: COLORS.textMuted, fontWeight: '600', fontSize: 15 },
})
