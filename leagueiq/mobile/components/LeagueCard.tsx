import { TouchableOpacity, View, Text, StyleSheet } from 'react-native'
import { LinearGradient } from 'expo-linear-gradient'
import type { League, LeagueMastery } from '../types'
import { LEAGUE_GRADIENTS, LEAGUE_NAMES } from '../lib/colors'

interface Props {
  league: League
  mastery?: LeagueMastery | null
  bestScore?: number
  onPress: () => void
  compact?: boolean
}

const MASTERY_ORDER = ['Rookie', 'Fan', 'Expert', 'Ultras👑']

export default function LeagueCard({ league, mastery, bestScore, onPress, compact }: Props) {
  const gradient = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
  const masteryLabel = mastery?.mastery_level ?? 'Rookie'
  const masteryIndex = MASTERY_ORDER.indexOf(masteryLabel)
  const progressPct = Math.round(((masteryIndex + 1) / MASTERY_ORDER.length) * 100)

  if (compact) {
    return (
      <TouchableOpacity onPress={onPress} activeOpacity={0.8}>
        <LinearGradient colors={gradient} style={styles.compact} start={{ x: 0, y: 0 }} end={{ x: 1, y: 1 }}>
          <Text style={styles.compactName}>{LEAGUE_NAMES[league.slug] ?? league.name}</Text>
          <Text style={styles.compactMastery}>{masteryLabel}</Text>
        </LinearGradient>
      </TouchableOpacity>
    )
  }

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.85} style={styles.wrapper}>
      <LinearGradient colors={gradient} style={styles.card} start={{ x: 0, y: 0 }} end={{ x: 1, y: 1 }}>
        <View style={styles.top}>
          <View>
            <Text style={styles.leagueName}>{LEAGUE_NAMES[league.slug] ?? league.name}</Text>
            <Text style={styles.masteryLabel}>{masteryLabel}</Text>
          </View>
          {bestScore != null && (
            <View style={styles.scorePill}>
              <Text style={styles.scoreText}>Best {bestScore}</Text>
            </View>
          )}
        </View>

        <View style={styles.progressBg}>
          <View style={[styles.progressFill, { width: `${progressPct}%` as `${number}%` }]} />
        </View>
        <Text style={styles.progressLabel}>
          {mastery?.categories_completed ?? 0} / 7 categories
        </Text>
      </LinearGradient>
    </TouchableOpacity>
  )
}

const styles = StyleSheet.create({
  wrapper: { marginBottom: 12 },
  card: {
    borderRadius: 16,
    padding: 20,
  },
  top: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'flex-start',
    marginBottom:   16,
  },
  leagueName: {
    color:      '#fff',
    fontSize:   22,
    fontWeight: '800',
    letterSpacing: -0.5,
  },
  masteryLabel: {
    color:     'rgba(255,255,255,0.75)',
    fontSize:  13,
    marginTop: 2,
  },
  scorePill: {
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius:    8,
    paddingHorizontal: 10,
    paddingVertical:   4,
  },
  scoreText: { color: '#fff', fontSize: 12, fontWeight: '600' },
  progressBg: {
    backgroundColor: 'rgba(0,0,0,0.3)',
    borderRadius:    4,
    height:          4,
    overflow:        'hidden',
  },
  progressFill: {
    backgroundColor: 'rgba(255,255,255,0.9)',
    height:          4,
    borderRadius:    4,
  },
  progressLabel: {
    color:     'rgba(255,255,255,0.6)',
    fontSize:  12,
    marginTop: 6,
  },
  // compact variant
  compact: {
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical:   12,
    marginRight: 10,
  },
  compactName: {
    color:      '#fff',
    fontSize:   14,
    fontWeight: '700',
  },
  compactMastery: {
    color:     'rgba(255,255,255,0.7)',
    fontSize:  11,
    marginTop: 2,
  },
})
