import { useEffect, useState, useCallback } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator, RefreshControl,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { useAuth } from '../../contexts/AuthContext'
import LeagueCard from '../../components/LeagueCard'
import StreakBadge from '../../components/StreakBadge'
import LevelBadge from '../../components/LevelBadge'
import { COLORS, LEAGUE_NAMES } from '../../lib/colors'
import { fetchLeagues, fetchLeagueMastery, getQuestionOfTheDay } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'
import type { League, LeagueMastery, Question } from '../../types'

export default function HomeScreen() {
  const { profile } = useAuth()
  const router = useRouter()
  const setPending = useGameStore((s) => s.setPending)

  const [leagues, setLeagues] = useState<League[]>([])
  const [mastery, setMastery] = useState<LeagueMastery[]>([])
  const [qotd, setQotd] = useState<Question | null>(null)
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
      setQotd(q?.question ?? null)
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
            <Text style={styles.username}>@{profile?.username}</Text>
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
            <Text style={styles.sectionTitle}>Question of the Day</Text>
            <View style={styles.qotdCard}>
              <Text style={styles.qotdLeague}>
                {leagues.find((l) => l.id === qotd.league_id)
                  ? LEAGUE_NAMES[leagues.find((l) => l.id === qotd.league_id)!.slug]
                  : 'Football'}
              </Text>
              <Text style={styles.qotdText}>{qotd.question}</Text>
              <View style={styles.qotdAnswers}>
                {qotd.options.map((opt, i) => (
                  <View key={i} style={styles.qotdOption}>
                    <Text style={styles.qotdOptionText}>
                      {String.fromCharCode(65 + i)}. {opt}
                    </Text>
                  </View>
                ))}
              </View>
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
              onPress={() => router.push('/(app)/play')}
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
    backgroundColor: COLORS.surfaceAlt,
    borderRadius:    10,
    paddingHorizontal: 14,
    paddingVertical:   10,
  },
  qotdOptionText: { color: COLORS.textSecondary, fontSize: 14 },

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
