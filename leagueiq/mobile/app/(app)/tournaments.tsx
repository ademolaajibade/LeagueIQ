import { useEffect, useState } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator, Alert,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { supabase } from '../../lib/supabase'
import { enterTournament } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'
import { COLORS, LEAGUE_NAMES, LEAGUE_COLORS } from '../../lib/colors'

interface Tournament {
  id: string
  name: string
  league_id: string
  starts_at: string
  ends_at: string
  status: 'upcoming' | 'active' | 'completed'
  leagues: { slug: string; name: string } | null
}

export default function TournamentsScreen() {
  const router = useRouter()
  const { setSession } = useGameStore()
  const [tournaments, setTournaments] = useState<Tournament[]>([])
  const [loading, setLoading]         = useState(true)
  const [entering, setEntering]       = useState<string | null>(null)

  useEffect(() => {
    supabase
      .from('tournaments')
      .select('*, leagues(slug, name)')
      .eq('status', 'active')
      .order('ends_at', { ascending: true })
      .then(({ data, error }) => {
        if (!error && data) setTournaments(data as Tournament[])
        setLoading(false)
      })
  }, [])

  async function handleEnter(t: Tournament) {
    setEntering(t.id)
    try {
      const res = await enterTournament(t.id)
      setSession(res.session, res.questions)
      router.push('/game/quiz')
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Could not enter tournament')
    } finally {
      setEntering(null)
    }
  }

  function formatDate(iso: string) {
    return new Date(iso).toLocaleDateString('en-NG', {
      day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit',
    })
  }

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>
        <Text style={styles.heading}>Tournaments</Text>
        <Text style={styles.subheading}>Compete for the top spot in weekly competitions</Text>

        {loading ? (
          <ActivityIndicator color={COLORS.gold} style={{ marginTop: 40 }} />
        ) : tournaments.length === 0 ? (
          <View style={styles.emptyBox}>
            <Text style={styles.emptyIcon}>🏆</Text>
            <Text style={styles.emptyTitle}>No active tournaments</Text>
            <Text style={styles.emptyBody}>Check back soon — new tournaments start weekly.</Text>
          </View>
        ) : (
          tournaments.map((t) => {
            const slug   = t.leagues?.slug ?? ''
            const accent = LEAGUE_COLORS[slug] ?? COLORS.gold
            const busy   = entering === t.id
            return (
              <View key={t.id} style={[styles.card, { borderColor: accent + '44' }]}>
                <View style={[styles.leaguePill, { backgroundColor: accent + '1A' }]}>
                  <Text style={[styles.leaguePillText, { color: accent }]}>
                    {LEAGUE_NAMES[slug] ?? t.leagues?.name ?? 'Tournament'}
                  </Text>
                </View>
                <Text style={styles.tournamentName}>{t.name}</Text>
                <Text style={styles.dateRow}>Ends {formatDate(t.ends_at)}</Text>
                <TouchableOpacity
                  style={[styles.enterBtn, { backgroundColor: accent }, busy && styles.btnDisabled]}
                  onPress={() => handleEnter(t)}
                  disabled={busy}
                  activeOpacity={0.8}
                >
                  {busy
                    ? <ActivityIndicator color="#000" size="small" />
                    : <Text style={styles.enterBtnText}>Enter & Play</Text>
                  }
                </TouchableOpacity>
              </View>
            )
          })
        )}
      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:       { flex: 1, backgroundColor: COLORS.background },
  scroll:     { padding: 20, paddingBottom: 40 },
  heading:    { color: COLORS.textPrimary, fontSize: 28, fontWeight: '800', marginBottom: 4 },
  subheading: { color: COLORS.textMuted, fontSize: 14, marginBottom: 28 },

  emptyBox: { alignItems: 'center', paddingVertical: 60, gap: 10 },
  emptyIcon:  { fontSize: 48 },
  emptyTitle: { color: COLORS.textPrimary, fontSize: 18, fontWeight: '700' },
  emptyBody:  { color: COLORS.textMuted, fontSize: 14, textAlign: 'center' },

  card: {
    backgroundColor: COLORS.surface,
    borderRadius:    18,
    borderWidth:     1,
    padding:         20,
    marginBottom:    16,
    gap:             10,
  },
  leaguePill: {
    alignSelf:         'flex-start',
    borderRadius:      20,
    paddingHorizontal: 10,
    paddingVertical:   4,
  },
  leaguePillText:  { fontSize: 12, fontWeight: '700' },
  tournamentName:  { color: COLORS.textPrimary, fontSize: 18, fontWeight: '800' },
  dateRow:         { color: COLORS.textMuted, fontSize: 13 },
  enterBtn: {
    borderRadius:    12,
    paddingVertical: 12,
    alignItems:      'center',
    marginTop:       4,
  },
  enterBtnText: { color: '#000', fontWeight: '700', fontSize: 15 },
  btnDisabled:  { opacity: 0.4 },
})
