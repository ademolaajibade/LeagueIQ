import { useRef, useEffect } from 'react'
import { View, Animated, StyleSheet, type DimensionValue } from 'react-native'

interface Props {
  durationMs: number
  running: boolean
  onExpire: () => void
}

export default function TimerBar({ durationMs, running, onExpire }: Props) {
  const progress = useRef(new Animated.Value(1)).current
  const animation = useRef<Animated.CompositeAnimation | null>(null)

  useEffect(() => {
    if (!running) {
      animation.current?.stop()
      return
    }
    progress.setValue(1)
    animation.current = Animated.timing(progress, {
      toValue:         0,
      duration:        durationMs,
      useNativeDriver: false,
    })
    animation.current.start(({ finished }) => {
      if (finished) onExpire()
    })
    return () => animation.current?.stop()
  }, [running, durationMs])

  const barColor = progress.interpolate({
    inputRange:  [0, 0.25, 0.5, 1],
    outputRange: ['#EF4444', '#EF4444', '#F5C518', '#22C55E'],
  })

  const widthPct = progress.interpolate({
    inputRange:  [0, 1],
    outputRange: ['0%', '100%'],
  })

  return (
    <View style={styles.track}>
      <Animated.View style={[styles.fill, { width: widthPct as unknown as DimensionValue, backgroundColor: barColor }]} />
    </View>
  )
}

const styles = StyleSheet.create({
  track: {
    height:          6,
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius:    3,
    overflow:        'hidden',
  },
  fill: {
    height:       6,
    borderRadius: 3,
  },
})
