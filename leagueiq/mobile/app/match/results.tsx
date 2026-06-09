import { View, Text, StyleSheet, TouchableOpacity } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useLocalSearchParams, useRouter } from 'expo-router'
import { useAuth } from '../../contexts/AuthContext'
import { COLORS } from '../../lib/colors'
import { useGameStore } from '../../store/gameStore'

export default function MatchResultsScreen() {
  const { match_id, winner_id } = useLocalSearchParams<{ match_id: string; winner_id: string }>()
  const { profile } = useAuth()
  const router = useRouter()
  const reset  = useGameStore((s) => s.reset)

  const isWinner = winner_id === profile?.id
  const isTie    = !winner_id

  function handleDone() {
    reset()
    router.replace('/(app)')
  }

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.content}>
        <Text style={styles.emoji}>
          {isTie ? '🤝' : isWinner ? '🏆' : '😤'}
        </Text>
        <Text style={[styles.result, { color: isTie ? COLORS.textSecondary : isWinner ? COLORS.gold : COLORS.error }]}>
          {isTie ? "It's a Tie!" : isWinner ? 'You Won!' : 'You Lost'}
        </Text>
        <Text style={styles.xpNote}>
          {isWinner ? '+50 XP' : isTie ? '+30 XP' : '+20 XP'}
        </Text>
        <Text style={styles.sub}>
          {isWinner
            ? 'Great game! XP has been added to your profile.'
            : isTie
            ? 'Neck and neck! Well played by both.'
            : 'Better luck next time. Keep practicing!'}
        </Text>

        <TouchableOpacity style={styles.btn} onPress={handleDone} activeOpacity={0.85}>
          <Text style={styles.btnText}>Back to Home</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.rematchBtn}
          onPress={() => { reset(); router.replace('/match/lobby') }}
          activeOpacity={0.8}
        >
          <Text style={styles.rematchText}>Rematch</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:    { flex: 1, backgroundColor: COLORS.background },
  content: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 32, gap: 12 },

  emoji:  { fontSize: 64, marginBottom: 8 },
  result: { fontSize: 36, fontWeight: '900', letterSpacing: -0.5 },
  xpNote: { color: COLORS.gold, fontSize: 18, fontWeight: '800' },
  sub: {
    color:      COLORS.textSecondary,
    fontSize:   15,
    textAlign:  'center',
    lineHeight: 22,
    marginBottom: 24,
  },

  btn: {
    width:           '100%',
    backgroundColor: COLORS.gold,
    borderRadius:    14,
    paddingVertical: 16,
    alignItems:      'center',
  },
  btnText: { color: '#000', fontWeight: '800', fontSize: 16 },

  rematchBtn: {
    width:           '100%',
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    paddingVertical: 14,
    alignItems:      'center',
  },
  rematchText: { color: COLORS.textSecondary, fontWeight: '600', fontSize: 15 },
})
