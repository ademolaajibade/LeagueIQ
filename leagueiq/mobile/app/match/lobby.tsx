import { useState } from 'react'
import {
  View, Text, StyleSheet, TouchableOpacity,
  TextInput, ActivityIndicator, Alert,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { COLORS } from '../../lib/colors'
import { fetchLeagues, createMatch, joinMatch } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'

type Tab = 'create' | 'join'

export default function LobbyScreen() {
  const router = useRouter()
  const { pending } = useGameStore()

  const [tab, setTab]         = useState<Tab>('create')
  const [joinCode, setJoinCode] = useState('')
  const [loading, setLoading]  = useState(false)
  const [matchId, setMatchId]  = useState<string | null>(null)
  const [myJoinCode, setMyJoinCode] = useState<string | null>(null)

  async function handleCreate() {
    if (!pending?.league) {
      Alert.alert('Error', 'Please select a league first')
      router.replace('/(app)/play')
      return
    }
    setLoading(true)
    try {
      const res = await createMatch({ league_id: pending.league.id })
      setMatchId(res.match_id)
      setMyJoinCode(res.join_code)
      router.push(`/match/${res.match_id}`)
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Could not create match')
    } finally {
      setLoading(false)
    }
  }

  async function handleJoin() {
    if (joinCode.trim().length < 6) {
      Alert.alert('Invalid Code', 'Enter the 8-character join code')
      return
    }
    setLoading(true)
    try {
      const res = await joinMatch(joinCode.trim().toUpperCase())
      router.push(`/match/${res.match_id}`)
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Invalid code or match not found')
    } finally {
      setLoading(false)
    }
  }

  return (
    <SafeAreaView style={styles.safe}>
      <TouchableOpacity onPress={() => router.back()} style={styles.backBtn} activeOpacity={0.7}>
        <Text style={styles.backText}>← Back</Text>
      </TouchableOpacity>

      <View style={styles.content}>
        <Text style={styles.title}>Head-to-Head</Text>
        <Text style={styles.sub}>Challenge another player to a live 1v1 match</Text>

        {/* Tabs */}
        <View style={styles.tabs}>
          <TouchableOpacity
            style={[styles.tab, tab === 'create' && styles.tabActive]}
            onPress={() => setTab('create')}
            activeOpacity={0.8}
          >
            <Text style={[styles.tabText, tab === 'create' && styles.tabTextActive]}>Create Match</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.tab, tab === 'join' && styles.tabActive]}
            onPress={() => setTab('join')}
            activeOpacity={0.8}
          >
            <Text style={[styles.tabText, tab === 'join' && styles.tabTextActive]}>Join Match</Text>
          </TouchableOpacity>
        </View>

        {tab === 'create' ? (
          <View style={styles.panel}>
            <Text style={styles.panelText}>
              Create a match and share your join code with a friend. The game starts when they join.
            </Text>
            {pending?.league && (
              <View style={styles.leaguePill}>
                <Text style={styles.leaguePillText}>{pending.league.name}</Text>
              </View>
            )}
            <TouchableOpacity
              style={styles.btn}
              onPress={handleCreate}
              disabled={loading}
              activeOpacity={0.85}
            >
              {loading ? (
                <ActivityIndicator color="#000" />
              ) : (
                <Text style={styles.btnText}>Create Match</Text>
              )}
            </TouchableOpacity>
          </View>
        ) : (
          <View style={styles.panel}>
            <Text style={styles.panelText}>Enter the 8-character join code from your opponent.</Text>
            <TextInput
              style={styles.input}
              value={joinCode}
              onChangeText={setJoinCode}
              placeholder="e.g. A1B2C3D4"
              placeholderTextColor={COLORS.textMuted}
              autoCapitalize="characters"
              maxLength={8}
            />
            <TouchableOpacity
              style={styles.btn}
              onPress={handleJoin}
              disabled={loading}
              activeOpacity={0.85}
            >
              {loading ? (
                <ActivityIndicator color="#000" />
              ) : (
                <Text style={styles.btnText}>Join Match</Text>
              )}
            </TouchableOpacity>
          </View>
        )}
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  backBtn:  { paddingHorizontal: 20, paddingTop: 16 },
  backText: { color: COLORS.textSecondary, fontSize: 15 },

  content: { flex: 1, padding: 24, justifyContent: 'center' },
  title:   { color: COLORS.textPrimary, fontSize: 30, fontWeight: '900', marginBottom: 6, letterSpacing: -0.5 },
  sub:     { color: COLORS.textMuted, fontSize: 14, marginBottom: 28, lineHeight: 20 },

  tabs: {
    flexDirection:   'row',
    backgroundColor: COLORS.surface,
    borderRadius:    12,
    padding:         4,
    marginBottom:    24,
  },
  tab: {
    flex:            1,
    paddingVertical: 10,
    borderRadius:    8,
    alignItems:      'center',
  },
  tabActive:     { backgroundColor: COLORS.gold },
  tabText:       { color: COLORS.textMuted, fontWeight: '600', fontSize: 14 },
  tabTextActive: { color: '#000' },

  panel: { gap: 16 },
  panelText: { color: COLORS.textSecondary, fontSize: 14, lineHeight: 20 },

  leaguePill: {
    backgroundColor: COLORS.surfaceAlt,
    borderRadius:    10,
    paddingHorizontal: 14,
    paddingVertical:   6,
    alignSelf:       'flex-start',
    borderWidth:     1,
    borderColor:     COLORS.border,
  },
  leaguePillText: { color: COLORS.textSecondary, fontWeight: '600', fontSize: 14 },

  input: {
    backgroundColor:   COLORS.surface,
    borderRadius:      12,
    borderWidth:       1,
    borderColor:       COLORS.border,
    paddingHorizontal: 16,
    paddingVertical:   14,
    color:             COLORS.textPrimary,
    fontSize:          18,
    fontWeight:        '700',
    letterSpacing:     3,
  },

  btn: {
    backgroundColor: COLORS.gold,
    borderRadius:    14,
    paddingVertical: 16,
    alignItems:      'center',
  },
  btnText: { color: '#000', fontWeight: '800', fontSize: 16 },
})
