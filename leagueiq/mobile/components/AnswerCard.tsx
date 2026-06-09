import { useRef, useEffect } from 'react'
import { TouchableOpacity, Text, StyleSheet, Animated } from 'react-native'
import * as Haptics from 'expo-haptics'
import { COLORS } from '../lib/colors'

type AnswerState = 'idle' | 'correct' | 'wrong' | 'revealed'

interface Props {
  label: string
  index: number
  state: AnswerState
  disabled: boolean
  accentColor: string
  onPress: (index: number) => void
}

export default function AnswerCard({ label, index, state, disabled, accentColor, onPress }: Props) {
  const scale = useRef(new Animated.Value(1)).current
  const bgOpacity = useRef(new Animated.Value(0)).current

  useEffect(() => {
    if (state === 'correct') {
      Animated.sequence([
        Animated.spring(scale, { toValue: 1.04, useNativeDriver: true, speed: 40 }),
        Animated.spring(scale, { toValue: 1, useNativeDriver: true, speed: 20 }),
      ]).start()
      Animated.timing(bgOpacity, { toValue: 1, duration: 150, useNativeDriver: false }).start()
    } else if (state === 'wrong') {
      Animated.sequence([
        Animated.timing(scale, { toValue: 0.97, duration: 60, useNativeDriver: true }),
        Animated.timing(scale, { toValue: 1.02, duration: 60, useNativeDriver: true }),
        Animated.timing(scale, { toValue: 0.98, duration: 60, useNativeDriver: true }),
        Animated.spring(scale, { toValue: 1, useNativeDriver: true }),
      ]).start()
      Animated.timing(bgOpacity, { toValue: 1, duration: 150, useNativeDriver: false }).start()
    } else {
      bgOpacity.setValue(0)
      scale.setValue(1)
    }
  }, [state])

  function handlePress() {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium)
    Animated.sequence([
      Animated.spring(scale, { toValue: 0.96, useNativeDriver: true, speed: 60 }),
      Animated.spring(scale, { toValue: 1, useNativeDriver: true, speed: 30 }),
    ]).start()
    onPress(index)
  }

  const borderColor = state === 'correct'
    ? COLORS.success
    : state === 'wrong'
      ? COLORS.error
      : state === 'revealed'
        ? COLORS.success
        : COLORS.border

  const overlayColor = bgOpacity.interpolate({
    inputRange:  [0, 1],
    outputRange: [
      'rgba(0,0,0,0)',
      state === 'correct' || state === 'revealed'
        ? 'rgba(34,197,94,0.15)'
        : 'rgba(239,68,68,0.15)',
    ],
  })

  return (
    <Animated.View style={[styles.wrapper, { transform: [{ scale }] }]}>
      <TouchableOpacity
        onPress={handlePress}
        disabled={disabled}
        activeOpacity={0.8}
        style={[styles.card, { borderColor }]}
      >
        <Animated.View style={[StyleSheet.absoluteFill, { backgroundColor: overlayColor, borderRadius: 14 }]} />
        <Text style={styles.indexLabel}>{String.fromCharCode(65 + index)}</Text>
        <Text style={styles.label}>{label}</Text>
      </TouchableOpacity>
    </Animated.View>
  )
}

const styles = StyleSheet.create({
  wrapper: { marginBottom: 10 },
  card: {
    backgroundColor:   COLORS.surface,
    borderRadius:      14,
    borderWidth:       1.5,
    paddingHorizontal: 16,
    paddingVertical:   18,
    flexDirection:     'row',
    alignItems:        'center',
    overflow:          'hidden',
  },
  indexLabel: {
    color:        COLORS.textMuted,
    fontSize:     14,
    fontWeight:   '700',
    marginRight:  12,
    width:        18,
    textAlign:    'center',
  },
  label: {
    color:      COLORS.textPrimary,
    fontSize:   16,
    fontWeight: '500',
    flex:       1,
    lineHeight: 22,
  },
})
