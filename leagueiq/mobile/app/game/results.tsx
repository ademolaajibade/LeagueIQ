import { useEffect, useRef, useState } from 'react'
import {
  View, Text, StyleSheet, Animated,
  TouchableOpacity, ScrollView,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import * as Haptics from 'expo-haptics'
import LevelBadge from '../../components/LevelBadge'
import StreakBadge from '../../components/StreakBadge'
import { COLORS, LEAGUE_COLORS } from '../../lib/colors'
import { useGameStore } from '../../store/gameStore'
import { useAuth } from '../../contexts/AuthContext'

export default function ResultsScreen() {
  const router = useRouter()
  const { endResult, pending, questions, answers, reset } = useGameStore()
  const { profile, refreshProfile } = useAuth()

  const xpAnim        = useRef(new Animated.Value(0)).current
  const scaleAnim     = useRef(new Animated.Value(0.6)).current
  const opacityAnim   = useRef(new Animated.Value(0)).current
  const [xpDisplay, setXpDisplay]     = useState(0)
  const [showLevelUp, setShowLevelUp] = useState(false)

  const accentColor = LEAGUE_COLORS[pending?.league?.slug ?? ''] ?? COLORS.gold
  const correctCount = answers.filter((a) => a.is_correct).length
  const total        = questions.length || 10
  const pct          = Math.round((correctCount / total) * 100)
  const xpEarned     = endResult?.xp_earned ?? 0

  useEffect(() => {
    Haptics.notificationAsync(
      pct >= 70
        ? Haptics.NotificationFeedbackType.Success
        : Haptics.NotificationFeedbackType.Warning,
    )

    Animated.parallel([
      Animated.spring(scaleAnim, { toValue: 1, useNativeDriver: true, tension: 80, friction: 7 }),
      Animated.timing(opacityAnim, { toValue: 1, duration: 400, useNativeDriver: true }),
    ]).start()

    Animated.timing(xpAnim, { toValue: xpEarned, duration: 1200, useNativeDriver: false }).start()
    xpAnim.addListener(({ value }) => setXpDisplay(Math.round(value)))

    if (endResult?.level_up) {
      setTimeout(() => setShowLevelUp(true), 1000)
    }

    refreshProfile()

    return () => xpAnim.removeAllListeners()
  }, [])

  function goHome() {
    reset()
    router.replace('/(app)')
  }

  function playAgain() {
    reset()
    router.replace('/(app)/play')
  }

  return (
    <SafeAreaView style={styles.safe}>
      {/* Level-up modal */}
      {showLevelUp && endResult?.level_up && (
        <View style={styles.levelUpOverlay}>
          <View style={styles.levelUpCard}>
            <Text style={styles.levelUpEmoji}>🎉</Text>
            <Text style={styles.levelUpTitle}>Level Up!</Text>
            <Text style={styles.levelUpSub}>You reached</Text>
            <LevelBadge level={endResult.level_up} xp={profile?.xp ?? 0} />
            <TouchableOpacity style={styles.levelUpBtn} onPress={() => setShowLevelUp(false)} activeOpacity={0.8}>
              <Text style={styles.levelUpBtnText}>Awesome!</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

        {/* Score circle */}
        <Animated.View style={[styles.scoreWrap, { transform: [{ scale: scaleAnim }], opacity: opacityAnim }]}>
          <Text style={[styles.pct, { color: accentColor }]}>{pct}%</Text>
          <Text style={styles.pctLabel}>{correctCount}/{total} correct</Text>
        </Animated.View>

        {/* XP earned */}
        <View style={styles.xpRow}>
          <Text style={styles.xpLabel}>XP Earned</Text>
          <Text style={[styles.xpValue, { color: COLORS.gold }]}>+{xpDisplay}</Text>
        </View>

        {/* Streak */}
        {(endResult?.streak ?? 0) > 0 && (
          <View style={styles.streakRow}>
            <StreakBadge streak={endResult!.streak} size="lg" />
            <Text style={styles.streakLabel}>day streak!</Text>
          </View>
        )}

        {/* Leaderboard position */}
        {endResult?.leaderboard_position != null && (
          <View style={styles.rankCard}>
            <Text style={styles.rankLabel}>Leaderboard</Text>
            <Text style={[styles.rankValue, { color: accentColor }]}>
              #{endResult.leaderboard_position}
            </Text>
          </View>
        )}

        {/* Answer breakdown */}
        <View style={styles.breakdown}>
          <Text style={styles.breakdownTitle}>Breakdown</Text>
          {questions.map((q, i) => {
            const ans = answers[i]
            const correct = ans?.is_correct
            return (
              <View key={q.id} style={styles.breakdownRow}>
                <Text style={correct ? styles.tick : styles.cross}>{correct ? '✓' : '✗'}</Text>
                <Text style={styles.breakdownQ} numberOfLines={2}>{q.question}</Text>
              </View>
            )
          })}
        </View>

        {/* Actions */}
        <View style={styles.actions}>
          <TouchableOpacity style={[styles.btn, { backgroundColor: accentColor }]} onPress={playAgain} activeOpacity={0.85}>
            <Text style={styles.btnTextDark}>Play Again</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.btnOutline} onPress={goHome} activeOpacity={0.8}>
            <Text style={styles.btnOutlineText}>Home</Text>
          </TouchableOpacity>
        </View>

      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 24, paddingBottom: 40, alignItems: 'center' },

  levelUpOverlay: {
    position:        'absolute',
    inset:           0,
    backgroundColor: 'rgba(8,11,20,0.92)',
    zIndex:          99,
    justifyContent:  'center',
    alignItems:      'center',
    padding:         32,
  },
  levelUpCard: {
    backgroundColor: COLORS.surface,
    borderRadius:    24,
    borderWidth:     1,
    borderColor:     COLORS.gold,
    padding:         32,
    alignItems:      'center',
    width:           '100%',
    gap:             10,
  },
  levelUpEmoji: { fontSize: 48 },
  levelUpTitle: { color: COLORS.textPrimary, fontSize: 28, fontWeight: '900' },
  levelUpSub:   { color: COLORS.textMuted, fontSize: 14 },
  levelUpBtn: {
    marginTop:       8,
    backgroundColor: COLORS.gold,
    borderRadius:    12,
    paddingVertical: 12,
    paddingHorizontal: 32,
  },
  levelUpBtnText: { color: '#000', fontWeight: '800', fontSize: 15 },

  scoreWrap: {
    backgroundColor: COLORS.surface,
    borderRadius:    80,
    width:           160,
    height:          160,
    justifyContent:  'center',
    alignItems:      'center',
    marginBottom:    24,
    borderWidth:     2,
    borderColor:     COLORS.border,
  },
  pct:      { fontSize: 44, fontWeight: '900', letterSpacing: -1 },
  pctLabel: { color: COLORS.textMuted, fontSize: 13, marginTop: 2 },

  xpRow: {
    flexDirection:  'row',
    alignItems:     'center',
    gap:            8,
    marginBottom:   16,
  },
  xpLabel: { color: COLORS.textSecondary, fontSize: 16 },
  xpValue: { fontSize: 24, fontWeight: '900' },

  streakRow: { flexDirection: 'row', alignItems: 'center', gap: 8, marginBottom: 16 },
  streakLabel: { color: COLORS.textSecondary, fontSize: 16 },

  rankCard: {
    backgroundColor:   COLORS.surface,
    borderRadius:      14,
    borderWidth:       1,
    borderColor:       COLORS.border,
    paddingHorizontal: 24,
    paddingVertical:   12,
    alignItems:        'center',
    marginBottom:      24,
    flexDirection:     'row',
    gap:               12,
  },
  rankLabel: { color: COLORS.textSecondary, fontSize: 14 },
  rankValue: { fontSize: 20, fontWeight: '900' },

  breakdown:      { width: '100%', marginBottom: 28 },
  breakdownTitle: {
    color:         COLORS.textSecondary,
    fontSize:      13,
    fontWeight:    '700',
    letterSpacing: 1,
    textTransform: 'uppercase',
    marginBottom:  10,
  },
  breakdownRow: {
    flexDirection: 'row',
    alignItems:    'flex-start',
    gap:           10,
    marginBottom:  8,
  },
  tick:         { color: COLORS.success, fontSize: 15, fontWeight: '800', marginTop: 1 },
  cross:        { color: COLORS.error, fontSize: 15, fontWeight: '800', marginTop: 1 },
  breakdownQ:   { color: COLORS.textSecondary, fontSize: 13, flex: 1, lineHeight: 18 },

  actions: { width: '100%', gap: 10 },
  btn: {
    borderRadius:    14,
    paddingVertical: 16,
    alignItems:      'center',
  },
  btnTextDark: { color: '#000', fontWeight: '800', fontSize: 16 },
  btnOutline: {
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    paddingVertical: 14,
    alignItems:      'center',
  },
  btnOutlineText: { color: COLORS.textSecondary, fontWeight: '600', fontSize: 15 },
})
