import { useEffect, useState } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useAuth } from '../../contexts/AuthContext'
import { COLORS, LEAGUE_NAMES } from '../../lib/colors'
import { getLeaderboard, fetchLeagues } from '../../lib/api'
import type { LeaderboardResponse, League } from '../../types'

type Period = 'all_time' | 'weekly' | 'survival'

const PERIODS: { key: Period; label: string }[] = [
  { key: 'all_time', label: 'All Time' },
  { key: 'weekly',   label: 'Weekly'   },
  { key: 'survival', label: 'Survival' },
]

const MEDALS = ['🥇', '🥈', '🥉']

export default function LeaderboardScreen() {
  const { profile } = useAuth()
  const [leagues, setLeagues] = useState<League[]>([])
  const [leagueIdx, setLeagueIdx] = useState(-1)  // -1 = global
  const [period, setPeriod] = useState<Period>('all_time')
  const [data, setData] = useState<LeaderboardResponse | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchLeagues().then(setLeagues)
  }, [])

  useEffect(() => {
    setLoading(true)
    const leagueId = leagueIdx >= 0 ? leagues[leagueIdx]?.id : undefined
    getLeaderboard({ league_id: leagueId, period, limit: 50 })
      .then(setData)
      .finally(() => setLoading(false))
  }, [leagueIdx, period, leagues])

  const entries = data?.entries ?? []
  const myRank  = data?.current_user_rank ?? null
  const top3    = entries.slice(0, 3)
  const rest    = entries.slice(3)

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.headerRow}>
        <Text style={styles.title}>Leaderboard</Text>
        {myRank != null && (
          <View style={styles.myRankPill}>
            <Text style={styles.myRankText}>#{myRank} You</Text>
          </View>
        )}
      </View>

      {/* Period tabs */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.tabsScroll} contentContainerStyle={styles.tabsContent}>
        {PERIODS.map((p) => (
          <TouchableOpacity
            key={p.key}
            onPress={() => setPeriod(p.key)}
            style={[styles.tab, period === p.key && styles.tabActive]}
            activeOpacity={0.7}
          >
            <Text style={[styles.tabText, period === p.key && styles.tabTextActive]}>{p.label}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {/* League tabs */}
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.tabsScroll} contentContainerStyle={styles.tabsContent}>
        <TouchableOpacity
          onPress={() => setLeagueIdx(-1)}
          style={[styles.tab, leagueIdx === -1 && styles.tabActive]}
          activeOpacity={0.7}
        >
          <Text style={[styles.tabText, leagueIdx === -1 && styles.tabTextActive]}>Global</Text>
        </TouchableOpacity>
        {leagues.map((l, i) => (
          <TouchableOpacity
            key={l.id}
            onPress={() => setLeagueIdx(i)}
            style={[styles.tab, leagueIdx === i && styles.tabActive]}
            activeOpacity={0.7}
          >
            <Text style={[styles.tabText, leagueIdx === i && styles.tabTextActive]}>
              {LEAGUE_NAMES[l.slug] ?? l.name}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>

      {loading ? (
        <ActivityIndicator color={COLORS.gold} style={{ marginTop: 60 }} />
      ) : (
        <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

          {/* Podium */}
          {top3.length > 0 && (
            <View style={styles.podiumRow}>
              {[top3[1], top3[0], top3[2]].filter(Boolean).map((entry, i) => {
                const rank  = i === 0 ? 2 : i === 1 ? 1 : 3
                const medal = MEDALS[rank - 1]
                const isMe  = entry?.user_id === profile?.id
                return (
                  <View key={entry?.id} style={[styles.podiumItem, rank === 1 && styles.podiumFirst]}>
                    <Text style={styles.podiumMedal}>{medal}</Text>
                    <View style={[styles.podiumCard, isMe && styles.podiumCardMe]}>
                      <Text style={styles.podiumName} numberOfLines={1}>
                        {entry?.profile?.username ?? '—'}
                      </Text>
                      <Text style={styles.podiumScore}>{entry?.total_score ?? entry?.weekly_score ?? 0}</Text>
                    </View>
                  </View>
                )
              })}
            </View>
          )}

          {/* Rest of list */}
          {rest.map((entry: LeaderboardResponse['entries'][number]) => {
            const isMe = entry.user_id === profile?.id
            return (
              <View key={entry.id} style={[styles.row, isMe && styles.rowMe]}>
                <Text style={styles.rowRank}>#{entry.rank}</Text>
                <View style={styles.rowInfo}>
                  <Text style={styles.rowName} numberOfLines={1}>
                    {entry.profile?.username ?? '—'}
                  </Text>
                  <Text style={styles.rowLevel}>{entry.profile?.level ?? ''}</Text>
                </View>
                <Text style={styles.rowScore}>
                  {period === 'weekly' ? entry.weekly_score : entry.total_score}
                </Text>
              </View>
            )
          })}

          {entries.length === 0 && (
            <Text style={styles.empty}>No entries yet. Be the first!</Text>
          )}
        </ScrollView>
      )}
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 20, paddingBottom: 32 },

  headerRow: {
    flexDirection:  'row',
    alignItems:     'center',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    paddingTop:     16,
    paddingBottom:  8,
  },
  title: { color: COLORS.textPrimary, fontSize: 26, fontWeight: '800', letterSpacing: -0.5 },
  myRankPill: {
    backgroundColor: 'rgba(245,197,24,0.12)',
    borderRadius:    10,
    paddingHorizontal: 10,
    paddingVertical:   4,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.3)',
  },
  myRankText: { color: COLORS.gold, fontSize: 13, fontWeight: '700' },

  tabsScroll:   { maxHeight: 44 },
  tabsContent:  { paddingHorizontal: 16, paddingVertical: 6, gap: 8 },
  tab:          {
    paddingHorizontal: 14,
    paddingVertical:   6,
    borderRadius:      20,
    backgroundColor:   COLORS.surface,
    borderWidth:       1,
    borderColor:       COLORS.border,
  },
  tabActive:     { backgroundColor: COLORS.gold, borderColor: COLORS.gold },
  tabText:       { color: COLORS.textMuted, fontSize: 13, fontWeight: '600' },
  tabTextActive: { color: '#000' },

  podiumRow:    {
    flexDirection:  'row',
    justifyContent: 'center',
    alignItems:     'flex-end',
    gap:            10,
    marginBottom:   24,
  },
  podiumItem:  { alignItems: 'center', flex: 1 },
  podiumFirst: { marginBottom: 12 },
  podiumMedal: { fontSize: 24, marginBottom: 6 },
  podiumCard:  {
    backgroundColor: COLORS.surface,
    borderRadius:    12,
    padding:         10,
    alignItems:      'center',
    borderWidth:     1,
    borderColor:     COLORS.border,
    width:           '100%',
  },
  podiumCardMe: { borderColor: COLORS.gold },
  podiumName:   { color: COLORS.textPrimary, fontSize: 12, fontWeight: '700' },
  podiumScore:  { color: COLORS.gold, fontSize: 16, fontWeight: '800', marginTop: 2 },

  row: {
    flexDirection:   'row',
    alignItems:      'center',
    backgroundColor: COLORS.surface,
    borderRadius:    12,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         14,
    marginBottom:    8,
    gap:             12,
  },
  rowMe:    { borderColor: COLORS.gold },
  rowRank:  { color: COLORS.textMuted, fontSize: 14, fontWeight: '700', width: 36 },
  rowInfo:  { flex: 1 },
  rowName:  { color: COLORS.textPrimary, fontSize: 15, fontWeight: '600' },
  rowLevel: { color: COLORS.textMuted, fontSize: 12, marginTop: 1 },
  rowScore: { color: COLORS.gold, fontSize: 16, fontWeight: '800' },

  empty: { color: COLORS.textMuted, textAlign: 'center', marginTop: 40, fontSize: 15 },
})
