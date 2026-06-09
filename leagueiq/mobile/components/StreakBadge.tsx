import { View, Text, StyleSheet } from 'react-native'
import { COLORS } from '../lib/colors'

interface Props {
  streak: number
  size?: 'sm' | 'lg'
}

export default function StreakBadge({ streak, size = 'sm' }: Props) {
  if (streak === 0) return null
  const isLg = size === 'lg'
  return (
    <View style={[styles.badge, isLg && styles.badgeLg]}>
      <Text style={[styles.fire, isLg && styles.fireLg]}>🔥</Text>
      <Text style={[styles.count, isLg && styles.countLg]}>{streak}</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  badge: {
    flexDirection:   'row',
    alignItems:      'center',
    backgroundColor: 'rgba(245,197,24,0.12)',
    borderRadius:    10,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.3)',
    paddingHorizontal: 8,
    paddingVertical:   3,
    gap: 3,
  },
  badgeLg: {
    paddingHorizontal: 14,
    paddingVertical:   8,
    borderRadius:      14,
  },
  fire:    { fontSize: 14 },
  fireLg:  { fontSize: 24 },
  count:   { color: COLORS.gold, fontSize: 13, fontWeight: '700' },
  countLg: { fontSize: 24 },
})
