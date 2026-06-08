import { useEffect, useRef, useState } from 'react'
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  FlatList, ActivityIndicator, Alert, ScrollView,
} from 'react-native'
import { useRouter } from 'expo-router'
import { supabase } from '../../lib/supabase'
import { useAuth } from '../../contexts/AuthContext'
import type { League, Club } from '../../types'

type Step = 'username' | 'league' | 'club'

export default function OnboardingScreen() {
  const { session, refreshProfile } = useAuth()
  const router = useRouter()

  const [step, setStep]                       = useState<Step>('username')
  const [username, setUsername]               = useState('')
  const [usernameError, setUsernameError]     = useState('')
  const [checkingUsername, setChecking]       = useState(false)
  const [leagues, setLeagues]                 = useState<League[]>([])
  const [selectedLeague, setSelectedLeague]   = useState<League | null>(null)
  const [clubs, setClubs]                     = useState<Club[]>([])
  const [selectedClub, setSelectedClub]       = useState<Club | null>(null)
  const [saving, setSaving]                   = useState(false)

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  // Pre-fill username from email
  useEffect(() => {
    const emailPrefix = session?.user.email?.split('@')[0] ?? ''
    setUsername(emailPrefix.replace(/[^a-zA-Z0-9_]/g, ''))
  }, [session])

  // Load leagues once
  useEffect(() => {
    supabase
      .from('leagues')
      .select('id, slug, name, accent_color, logo_url, created_at')
      .then(({ data }) => data && setLeagues(data as League[]))
  }, [])

  // Load clubs when league is selected
  useEffect(() => {
    if (!selectedLeague) return
    setClubs([])
    supabase
      .from('clubs')
      .select('id, league_id, name, crest_url, created_at')
      .eq('league_id', selectedLeague.id)
      .order('name')
      .then(({ data }) => data && setClubs(data as Club[]))
  }, [selectedLeague])

  const validateUsername = (val: string): string => {
    if (val.length < 3)  return 'Must be at least 3 characters'
    if (val.length > 20) return 'Must be 20 characters or fewer'
    if (!/^[a-zA-Z0-9_]+$/.test(val)) return 'Letters, numbers, and underscores only'
    return ''
  }

  const onUsernameChange = (val: string) => {
    setUsername(val)
    const err = validateUsername(val)
    setUsernameError(err)
    if (err) return

    if (debounceRef.current) clearTimeout(debounceRef.current)
    setChecking(true)
    debounceRef.current = setTimeout(async () => {
      const { data } = await supabase
        .from('profiles')
        .select('id')
        .eq('username', val)
        .neq('id', session!.user.id)
        .maybeSingle()
      setChecking(false)
      if (data) setUsernameError('Username is already taken')
    }, 500)
  }

  const goToLeague = () => {
    const err = validateUsername(username)
    if (err) { setUsernameError(err); return }
    if (checkingUsername || usernameError) return
    setStep('league')
  }

  const goToClub = (league: League) => {
    setSelectedLeague(league)
    setSelectedClub(null)
    setStep('club')
  }

  const finish = async (skipClub = false) => {
    setSaving(true)
    const { error } = await supabase
      .from('profiles')
      .update({
        username,
        preferred_league_id:  selectedLeague?.id ?? null,
        club_id:              skipClub ? null : (selectedClub?.id ?? null),
        onboarding_completed: true,
      })
      .eq('id', session!.user.id)

    setSaving(false)
    if (error) { Alert.alert('Error', error.message); return }

    await refreshProfile()
    router.replace('/(app)/')
  }

  // ── Step 1: Username ──────────────────────────────────────────
  if (step === 'username') {
    return (
      <View style={styles.container}>
        <View style={styles.inner}>
          <Text style={styles.step}>Step 1 of 3</Text>
          <Text style={styles.title}>Pick your username</Text>
          <Text style={styles.desc}>This is how other players will know you.</Text>

          <TextInput
            style={[styles.input, !!usernameError && styles.inputError]}
            value={username}
            onChangeText={onUsernameChange}
            autoCapitalize="none"
            autoCorrect={false}
            placeholder="username"
            placeholderTextColor="#555"
          />

          {checkingUsername && (
            <Text style={styles.hint}>Checking availability…</Text>
          )}
          {!!usernameError && !checkingUsername && (
            <Text style={styles.error}>{usernameError}</Text>
          )}
          {!usernameError && !checkingUsername && username.length >= 3 && (
            <Text style={styles.success}>✓ @{username} is available</Text>
          )}

          <TouchableOpacity
            style={[styles.btn, (!!usernameError || checkingUsername) && styles.btnDisabled]}
            onPress={goToLeague}
            disabled={!!usernameError || checkingUsername}
          >
            <Text style={styles.btnText}>Continue</Text>
          </TouchableOpacity>
        </View>
      </View>
    )
  }

  // ── Step 2: League ────────────────────────────────────────────
  if (step === 'league') {
    return (
      <View style={styles.container}>
        <ScrollView contentContainerStyle={styles.inner} showsVerticalScrollIndicator={false}>
          <Text style={styles.step}>Step 2 of 3</Text>
          <Text style={styles.title}>Choose your league</Text>
          <Text style={styles.desc}>Which competition do you follow the most?</Text>

          {leagues.length === 0
            ? <ActivityIndicator color="#00e5a0" style={{ marginTop: 40 }} />
            : leagues.map((league) => (
                <TouchableOpacity
                  key={league.id}
                  style={[styles.leagueCard, { borderColor: league.accent_color }]}
                  onPress={() => goToClub(league)}
                >
                  <Text style={[styles.leagueName, { color: league.accent_color }]}>
                    {league.name}
                  </Text>
                  <Text style={styles.leagueArrow}>→</Text>
                </TouchableOpacity>
              ))
          }
        </ScrollView>
      </View>
    )
  }

  // ── Step 3: Club ──────────────────────────────────────────────
  return (
    <View style={styles.container}>
      <View style={styles.inner}>
        <Text style={styles.step}>Step 3 of 3</Text>
        <Text style={styles.title}>Pick your club</Text>
        <Text style={styles.desc}>
          Your team in{' '}
          <Text style={{ color: selectedLeague?.accent_color }}>
            {selectedLeague?.name}
          </Text>
          ?
        </Text>

        {clubs.length === 0
          ? <ActivityIndicator color="#00e5a0" style={{ marginTop: 40 }} />
          : (
            <FlatList
              data={clubs}
              keyExtractor={(c) => c.id}
              numColumns={2}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={[
                    styles.clubCard,
                    selectedClub?.id === item.id && {
                      borderColor:     selectedLeague?.accent_color ?? '#00e5a0',
                      backgroundColor: '#1c1c1c',
                    },
                  ]}
                  onPress={() => setSelectedClub(item)}
                >
                  <Text style={styles.clubName}>{item.name}</Text>
                </TouchableOpacity>
              )}
              columnWrapperStyle={{ gap: 10 }}
              contentContainerStyle={{ gap: 10, paddingBottom: 12 }}
              scrollEnabled={false}
            />
          )
        }

        <View style={styles.row}>
          <TouchableOpacity
            style={styles.skipBtn}
            onPress={() => finish(true)}
            disabled={saving}
          >
            <Text style={styles.skipText}>Skip</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={[styles.btn, { flex: 1 }, !selectedClub && styles.btnDisabled]}
            onPress={() => finish(false)}
            disabled={!selectedClub || saving}
          >
            {saving
              ? <ActivityIndicator color="#000" />
              : <Text style={styles.btnText}>Let's go!</Text>
            }
          </TouchableOpacity>
        </View>
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a0a' },
  inner: {
    flexGrow:          1,
    paddingHorizontal: 24,
    paddingTop:        64,
    paddingBottom:     40,
  },
  step:  { color: '#555', fontSize: 13, marginBottom: 8, fontWeight: '600', letterSpacing: 1 },
  title: { fontSize: 28, fontWeight: '800', color: '#fff', marginBottom: 8, letterSpacing: -0.5 },
  desc:  { color: '#888', fontSize: 15, marginBottom: 32, lineHeight: 22 },
  input: {
    backgroundColor: '#1a1a1a',
    borderRadius:    12,
    padding:         16,
    color:           '#fff',
    fontSize:        18,
    borderWidth:     1,
    borderColor:     '#2a2a2a',
    marginBottom:    8,
  },
  inputError: { borderColor: '#ff4d4f' },
  hint:    { color: '#555', fontSize: 13, marginBottom: 8 },
  error:   { color: '#ff4d4f', fontSize: 13, marginBottom: 8 },
  success: { color: '#00e5a0', fontSize: 13, marginBottom: 8 },
  btn: {
    backgroundColor: '#00e5a0',
    borderRadius:    12,
    padding:         16,
    alignItems:      'center',
    marginTop:       16,
  },
  btnDisabled: { opacity: 0.35 },
  btnText:     { color: '#000', fontWeight: '700', fontSize: 16 },
  leagueCard: {
    flexDirection:  'row',
    justifyContent: 'space-between',
    alignItems:     'center',
    borderRadius:   12,
    borderWidth:    2,
    padding:        20,
    backgroundColor: '#111',
    marginBottom:   12,
  },
  leagueName:  { fontSize: 18, fontWeight: '700' },
  leagueArrow: { color: '#555', fontSize: 18 },
  clubCard: {
    flex:            1,
    borderRadius:    10,
    borderWidth:     1.5,
    borderColor:     '#2a2a2a',
    padding:         14,
    backgroundColor: '#111',
    alignItems:      'center',
  },
  clubName: { color: '#fff', fontSize: 13, fontWeight: '600', textAlign: 'center' },
  row:      { flexDirection: 'row', gap: 12, marginTop: 8 },
  skipBtn: {
    borderRadius:    12,
    borderWidth:     1,
    borderColor:     '#2a2a2a',
    padding:         16,
    paddingHorizontal: 20,
    alignItems:      'center',
    justifyContent:  'center',
  },
  skipText: { color: '#666', fontWeight: '600', fontSize: 14 },
})
