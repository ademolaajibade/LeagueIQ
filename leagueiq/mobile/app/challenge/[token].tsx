import { useState } from 'react'
import {
  View, Text, StyleSheet, TouchableOpacity,
  ActivityIndicator, Alert, SafeAreaView,
} from 'react-native'
import { useLocalSearchParams, useRouter } from 'expo-router'
import { acceptChallenge } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'
import { COLORS } from '../../lib/colors'

export default function ChallengeAcceptScreen() {
  const { token }             = useLocalSearchParams<{ token: string }>()
  const router                = useRouter()
  const { setSession }        = useGameStore()
  const [loading, setLoading] = useState(false)
  const [error, setError]     = useState<string | null>(null)

  async function handleAccept() {
    if (!token) {
      Alert.alert('Error', 'Invalid challenge link.')
      return
    }
    setLoading(true)
    setError(null)
    try {
      const res = await acceptChallenge(token)
      setSession(res.session, res.questions)
      router.replace('/game/quiz')
    } catch (e: unknown) {
      setError(e instanceof Error ? e.message : 'Could not load challenge')
      setLoading(false)
    }
  }

  return (
    <SafeAreaView style={styles.safe}>
      <View style={styles.inner}>
        <Text style={styles.icon}>🤝</Text>
        <Text style={styles.title}>Friend Challenge</Text>
        <Text style={styles.body}>
          A friend has challenged you! Answer the same set of questions and see who scores higher.
        </Text>

        {error && <Text style={styles.error}>{error}</Text>}

        <TouchableOpacity
          style={[styles.acceptBtn, loading && styles.btnDisabled]}
          onPress={handleAccept}
          disabled={loading}
          activeOpacity={0.85}
        >
          {loading
            ? <ActivityIndicator color="#000" />
            : <Text style={styles.acceptText}>Accept Challenge</Text>
          }
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.declineBtn}
          onPress={() => router.replace('/(app)')}
          disabled={loading}
        >
          <Text style={styles.declineText}>Decline</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:  { flex: 1, backgroundColor: COLORS.background },
  inner: {
    flex:              1,
    justifyContent:    'center',
    alignItems:        'center',
    paddingHorizontal: 32,
    gap:               16,
  },
  icon:  { fontSize: 64 },
  title: { color: COLORS.textPrimary, fontSize: 28, fontWeight: '800', textAlign: 'center' },
  body:  { color: COLORS.textSecondary, fontSize: 15, lineHeight: 22, textAlign: 'center' },
  error: { color: COLORS.error, fontSize: 13, textAlign: 'center' },
  acceptBtn: {
    backgroundColor: COLORS.gold,
    borderRadius:    16,
    paddingVertical: 16,
    paddingHorizontal: 48,
    alignItems:      'center',
    marginTop:       8,
  },
  acceptText:  { color: '#000', fontWeight: '800', fontSize: 16 },
  declineBtn:  { paddingVertical: 12, paddingHorizontal: 24 },
  declineText: { color: COLORS.textMuted, fontSize: 14, fontWeight: '600' },
  btnDisabled: { opacity: 0.4 },
})
