import { View, Text, StyleSheet } from 'react-native'
import type { UserLevel } from '../types'
import { LEVEL_COLORS } from '../lib/colors'

interface Props {
  level: UserLevel
  xp: number
  nextXp?: number
  showBar?: boolean
}

const LEVEL_XP: Record<UserLevel, number> = {
  Bronze:   0,
  Silver:   500,
  Gold:     1500,
  Platinum: 3500,
  Legend:   7500,
}

export default function LevelBadge({ level, xp, showBar }: Props) {
  const color = LEVEL_COLORS[level] ?? '#888'
  const current = LEVEL_XP[level] ?? 0
  const levels: UserLevel[] = ['Bronze', 'Silver', 'Gold', 'Platinum', 'Legend']
  const nextLevel = levels[levels.indexOf(level) + 1]
  const nextThreshold = nextLevel ? LEVEL_XP[nextLevel] : null
  const progress = nextThreshold
    ? Math.min(1, (xp - current) / (nextThreshold - current))
    : 1

  return (
    <View style={styles.container}>
      <View style={[styles.badge, { borderColor: color }]}>
        <Text style={[styles.label, { color }]}>{level}</Text>
      </View>
      {showBar && (
        <View style={styles.barWrap}>
          <View style={styles.barBg}>
            <View style={[styles.barFill, { width: `${Math.round(progress * 100)}%` as `${number}%`, backgroundColor: color }]} />
          </View>
          <Text style={styles.xpText}>
            {xp.toLocaleString()} XP{nextThreshold ? ` / ${nextThreshold.toLocaleString()}` : ''}
          </Text>
        </View>
      )}
    </View>
  )
}

const styles = StyleSheet.create({
  container: { alignItems: 'flex-start' },
  badge: {
    borderRadius:    20,
    borderWidth:     1.5,
    paddingHorizontal: 12,
    paddingVertical:   4,
  },
  label: { fontSize: 13, fontWeight: '700', letterSpacing: 0.5 },
  barWrap: { marginTop: 8, width: '100%' },
  barBg: {
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius:    4,
    height:          6,
    overflow:        'hidden',
  },
  barFill: { height: 6, borderRadius: 4 },
  xpText: { color: '#94A3B8', fontSize: 12, marginTop: 4 },
})
