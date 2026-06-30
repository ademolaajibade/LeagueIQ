import { useEffect, useState, useCallback } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator, RefreshControl, Pressable,
} from 'react-native'
import AsyncStorage from '@react-native-async-storage/async-storage'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { useAuth } from '../../contexts/AuthContext'
import LeagueCard from '../../components/LeagueCard'
import StreakBadge from '../../components/StreakBadge'
import LevelBadge from '../../components/LevelBadge'
import { COLORS, LEAGUE_NAMES } from '../../lib/colors'
import { fetchLeagues, fetchLeagueMastery, getQuestionOfTheDay, submitQotdAnswer } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'
import type { League, LeagueMastery, Question } from '../../types'

export default function HomeScreen() {
  const { profile } = useAuth()
  const router = useRouter()
  const setPending = useGameStore((s) => s.setPending)

  const [leagues, setLeagues] = useState<League[]>([])
  const [mastery, setMastery] = useState<LeagueMastery[]>([])
  const [qotd, setQotd] = useState<Question | null>(null)
  const [qotdPick, setQotdPick] = useState<number | null>(null)
  const [loading, setLoading] = useState(true)
  const [refreshing, setRefreshing] = useState(false)

  const load = useCallback(async () => {
    try {
      const [ls, ms, q] = await Promise.all([
        fetchLeagues(),
        profile ? fetchLeagueMastery(profile.id) : Promise.resolve([]),
        getQuestionOfTheDay().catch(() => null),
      ])
      setLeagues(ls)
      setMastery(ms)
      const question = q?.question ?? null
      setQotd(question)
      if (question) {
        // Prefer server-side answer (survives reinstall); fall back to date-keyed AsyncStorage
        const today = new Date().toISOString().split('T')[0]
        if (q?.user_pick != null) {
          setQotdPick(q.user_pick)
        } else {
          const saved = await AsyncStorage.getItem(`qotd_pick_${today}`)
          if (saved !== null) setQotdPick(Number(saved))
        }
      }
    } finally {
      setLoading(false)
      setRefreshing(false)
    }
  }, [profile?.id])

  useEffect(() => { load() }, [load])

  function getMastery(leagueId: string) {
    return mastery.find((m) => m.league_id === leagueId) ?? null
  }

  function handleLeaguePress(league: League) {
    setPending({ league, mode: 'quick_play', category: null })
    router.push('/(app)/play')
  }

  if (loading) {
    return (
      <SafeAreaView style={styles.safe}>
        <ActivityIndicator color={COLORS.gold} style={{ marginTop: 80 }} />
      </SafeAreaView>
    )
  }

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView
        contentContainerStyle={styles.scroll}
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={() => { setRefreshing(true); load() }}
            tintColor={COLORS.gold}
          />
        }
      >
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Welcome back,</Text>
            <Text style={styles.username}>{profile?.username}</Text>
          </View>
          <View style={styles.headerRight}>
            <StreakBadge streak={profile?.streak ?? 0} />
            {profile && (
              <LevelBadge level={profile.level} xp={profile.xp} />
            )}
          </View>
        </View>

        {/* XP bar */}
        {profile && (
          <View style={styles.xpRow}>
            <LevelBadge level={profile.level} xp={profile.xp} showBar />
          </View>
        )}

        {/* Question of the Day */}
        {qotd && (
          <View style={styles.section}>
            <View style={styles.sectionHeader}>
              <Text style={styles.sectionTitle}>Question of the Day</Text>
              {qotdPick !== null && (
                <View style={styles.completedBadge}>
                  <Text style={styles.completedBadgeText}>✓ Completed</Text>
                </View>
              )}
            </View>
            <View style={styles.qotdCard}>
              <Text style={styles.qotdLeague}>
                {leagues.find((l) => l.id === qotd.league_id)
                  ? LEAGUE_NAMES[leagues.find((l) => l.id === qotd.league_id)!.slug]
                  : 'Football'}
              </Text>
              <Text style={styles.qotdText}>{qotd.question}</Text>
              <View style={styles.qotdAnswers}>
                {qotd.options.map((opt, i) => {
                  const picked    = qotdPick !== null
                  const isCorrect = i === qotd.correct_answer
                  const isPicked  = i === qotdPick
                  const optExtra  = picked && isCorrect ? styles.qotdCorrect : picked && isPicked ? styles.qotdWrong : null
                  const textColor = picked && isCorrect ? COLORS.success    : picked && isPicked ? COLORS.error    : undefined
                  return (
                    <Pressable
                      key={i}
                      onPress={() => {
                        if (qotdPick === null) {
                          const today = new Date().toISOString().split('T')[0]
                          setQotdPick(i)
                          AsyncStorage.setItem(`qotd_pick_${today}`, String(i))
                          submitQotdAnswer(qotd!.id, i).catch(() => {/* fire-and-forget */})
                        }
                      }}
                      style={[styles.qotdOption, optExtra]}
                    >
                      <Text style={styles.qotdLabel}>{String.fromCharCode(65 + i)}</Text>
                      <Text style={[styles.qotdOptionText, textColor ? { color: textColor } : null]}>{opt}</Text>
                    </Pressable>
                  )
                })}
              </View>
              {qotdPick !== null && qotd.fact && (
                <View style={styles.qotdFact}>
                  <Text style={styles.qotdFactLabel}>Did You Know?</Text>
                  <Text style={styles.qotdFactText}>{qotd.fact}</Text>
                </View>
              )}
              {qotdPick !== null && (
                <TouchableOpacity
                  style={styles.qotdPlayBtn}
                  onPress={() => router.push('/(app)/play')}
                  activeOpacity={0.8}
                >
                  <Text style={styles.qotdPlayText}>Play More →</Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
        )}

        {/* Leagues */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Leagues</Text>
          {leagues.map((league) => (
            <LeagueCard
              key={league.id}
              league={league}
              mastery={getMastery(league.id)}
              onPress={() => handleLeaguePress(league)}
            />
          ))}
        </View>

        {/* Quick actions */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Quick Play</Text>
          <View style={styles.quickRow}>
            <TouchableOpacity
              style={styles.quickBtn}
              onPress={() => router.push('/(app)/play')}
              activeOpacity={0.8}
            >
              <Text style={styles.quickIcon}>⚡</Text>
              <Text style={styles.quickLabel}>Quick Play</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={styles.quickBtn}
              onPress={() => router.push('/(app)/play')}
              activeOpacity={0.8}
            >
              <Text style={styles.quickIcon}>📅</Text>
              <Text style={styles.quickLabel}>Daily Challenge</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={styles.quickBtn}
              onPress={() => router.push('/(app)/tournaments')}
              activeOpacity={0.8}
            >
              <Text style={styles.quickIcon}>🏆</Text>
              <Text style={styles.quickLabel}>Tournament</Text>
            </TouchableOpacity>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 20, paddingBottom: 32 },

  header: {
    flexDirection:   'row',
    justifyContent:  'space-between',
    alignItems:      'flex-start',
    marginBottom:    20,
  },
  greeting: { color: COLORS.textMuted, fontSize: 14 },
  username: { color: COLORS.textPrimary, fontSize: 24, fontWeight: '800', letterSpacing: -0.5 },
  headerRight: { alignItems: 'flex-end', gap: 6 },

  xpRow: { marginBottom: 24 },

  section:      { marginBottom: 28 },
  sectionHeader: {
    flexDirection:  'row',
    alignItems:     'center',
    justifyContent: 'space-between',
    marginBottom:   12,
  },
  completedBadge: {
    backgroundColor: 'rgba(34,197,94,0.15)',
    borderRadius:    12,
    paddingHorizontal: 8,
    paddingVertical:   3,
  },
  completedBadgeText: {
    color:      '#4ade80',
    fontSize:   11,
    fontWeight: '700',
  },
  sectionTitle: {
    color:         COLORS.textSecondary,
    fontSize:      13,
    fontWeight:    '700',
    letterSpacing: 1,
    textTransform: 'uppercase',
    marginBottom:  12,
  },

  qotdCard: {
    backgroundColor: COLORS.surface,
    borderRadius:    16,
    padding:         20,
    borderWidth:     1,
    borderColor:     COLORS.border,
  },
  qotdLeague: {
    color:         COLORS.gold,
    fontSize:      11,
    fontWeight:    '700',
    letterSpacing: 1,
    textTransform: 'uppercase',
    marginBottom:  8,
  },
  qotdText: {
    color:        COLORS.textPrimary,
    fontSize:     17,
    fontWeight:   '600',
    lineHeight:   24,
    marginBottom: 16,
  },
  qotdAnswers: { gap: 8 },
  qotdOption: {
    flexDirection:   'row',
    alignItems:      'center',
    gap:             10,
    backgroundColor: COLORS.surfaceAlt,
    borderRadius:    10,
    paddingHorizontal: 12,
    paddingVertical:   10,
    borderWidth:     1,
    borderColor:     'transparent',
  },
  qotdCorrect: { backgroundColor: 'rgba(34,197,94,0.12)', borderColor: COLORS.success },
  qotdWrong:   { backgroundColor: 'rgba(239,68,68,0.12)', borderColor: COLORS.error },
  qotdLabel: {
    width:        24,
    height:       24,
    borderRadius: 12,
    backgroundColor: 'rgba(255,255,255,0.08)',
    textAlign:    'center',
    lineHeight:   24,
    fontSize:     12,
    fontWeight:   '700',
    color:        COLORS.textMuted,
  },
  qotdOptionText: { color: COLORS.textSecondary, fontSize: 14, flex: 1 },
  qotdFact: {
    marginTop:       12,
    padding:         12,
    borderRadius:    10,
    backgroundColor: COLORS.surfaceAlt,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.2)',
  },
  qotdFactLabel: { color: COLORS.gold, fontSize: 11, fontWeight: '700', letterSpacing: 0.8, textTransform: 'uppercase', marginBottom: 4 },
  qotdFactText:  { color: COLORS.textSecondary, fontSize: 13, lineHeight: 19 },
  qotdPlayBtn: {
    marginTop:        12,
    backgroundColor:  COLORS.gold,
    borderRadius:     10,
    paddingVertical:  12,
    alignItems:       'center',
  },
  qotdPlayText: { color: '#000', fontSize: 14, fontWeight: '700' },

  quickRow: { flexDirection: 'row', gap: 10 },
  quickBtn: {
    flex:              1,
    backgroundColor:   COLORS.surface,
    borderRadius:      14,
    borderWidth:       1,
    borderColor:       COLORS.border,
    paddingVertical:   16,
    alignItems:        'center',
    gap:               6,
  },
  quickIcon:  { fontSize: 22 },
  quickLabel: { color: COLORS.textSecondary, fontSize: 11, fontWeight: '600', textAlign: 'center' },
})
