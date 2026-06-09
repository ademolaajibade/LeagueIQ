import { useEffect, useState } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator, Alert,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { LinearGradient } from 'expo-linear-gradient'
import { useAuth } from '../../contexts/AuthContext'
import { COLORS, LEAGUE_GRADIENTS, LEAGUE_NAMES } from '../../lib/colors'
import { fetchLeagues, fetchCategories, startSession, getDailyChallenge, startSurvival as apiStartSurvival } from '../../lib/api'
import { useGameStore } from '../../store/gameStore'
import type { League, Category, GameMode } from '../../types'

type Step = 'league' | 'mode' | 'category'

const MODES: { mode: GameMode | 'survival' | 'h2h'; label: string; icon: string; desc: string; needsCategory: boolean }[] = [
  { mode: 'quick_play',       label: 'Quick Play',        icon: '⚡', desc: '10 questions, pick your category',     needsCategory: true  },
  { mode: 'daily_challenge',  label: 'Daily Challenge',   icon: '📅', desc: 'One per league, resets at midnight',   needsCategory: false },
  { mode: 'speed_round',      label: 'Speed Round',       icon: '⏱',  desc: '20 questions, 8 seconds each',        needsCategory: false },
  { mode: 'category_blitz',   label: 'Category Blitz',    icon: '🌍', desc: 'Random mix from all 5 leagues',       needsCategory: false },
  { mode: 'survival',         label: 'Survival Mode',     icon: '❤️', desc: 'One wrong answer ends everything',    needsCategory: false },
  { mode: 'h2h',              label: 'Head-to-Head',      icon: '🆚', desc: 'Live 1v1 match vs another player',    needsCategory: false },
]

const FREE_CATEGORY_LIMIT = 3

export default function PlayScreen() {
  const { profile } = useAuth()
  const router = useRouter()
  const { setPending, setSession, startSurvival: storeStartSurvival } = useGameStore()

  const [step, setStep] = useState<Step>('league')
  const [leagues, setLeagues] = useState<League[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null)
  const [selectedMode, setSelectedMode] = useState<typeof MODES[0] | null>(null)
  const [loading, setLoading] = useState(true)
  const [starting, setStarting] = useState(false)

  useEffect(() => {
    fetchLeagues().then(setLeagues).finally(() => setLoading(false))
  }, [])

  async function handleLeagueSelect(league: League) {
    setSelectedLeague(league)
    setStep('mode')
  }

  async function handleModeSelect(modeItem: typeof MODES[0]) {
    setSelectedMode(modeItem)

    if (modeItem.mode === 'h2h') {
      router.push('/match/lobby')
      return
    }

    if (!modeItem.needsCategory) {
      await launchGame(modeItem, null)
      return
    }

    setLoading(true)
    const cats = await fetchCategories(selectedLeague!.id).finally(() => setLoading(false))
    setCategories(cats)
    setStep('category')
  }

  async function handleCategorySelect(category: Category) {
    await launchGame(selectedMode!, category)
  }

  async function launchGame(modeItem: typeof MODES[0], category: Category | null) {
    if (!selectedLeague) return
    setStarting(true)
    try {
      if (modeItem.mode === 'survival') {
        const res = await apiStartSurvival({ league_id: selectedLeague.id })
        storeStartSurvival(res.session_id, res.question, selectedLeague.id)
        router.push('/game/survival')
        return
      }

      const gameMode = modeItem.mode as GameMode
      let res

      if (gameMode === 'daily_challenge') {
        res = await getDailyChallenge(selectedLeague.id)
      } else {
        res = await startSession({
          league_id:   selectedLeague.id,
          category_id: category?.id,
          mode:        gameMode,
        })
      }

      setSession(res.session, res.questions)
      setPending({ league: selectedLeague, mode: gameMode, category })
      router.push('/game/quiz')
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Could not start game')
    } finally {
      setStarting(false)
    }
  }

  function goBack() {
    if (step === 'mode')     setStep('league')
    if (step === 'category') setStep('mode')
  }

  if (loading && leagues.length === 0) {
    return (
      <SafeAreaView style={styles.safe}>
        <ActivityIndicator color={COLORS.gold} style={{ marginTop: 80 }} />
      </SafeAreaView>
    )
  }

  return (
    <SafeAreaView style={styles.safe}>
      {/* Header */}
      <View style={styles.header}>
        {step !== 'league' && (
          <TouchableOpacity onPress={goBack} style={styles.backBtn} activeOpacity={0.7}>
            <Text style={styles.backText}>← Back</Text>
          </TouchableOpacity>
        )}
        <Text style={styles.title}>
          {step === 'league' ? 'Pick a League' : step === 'mode' ? 'Game Mode' : 'Pick Category'}
        </Text>
        {selectedLeague && (
          <Text style={styles.subtitle}>{LEAGUE_NAMES[selectedLeague.slug]}</Text>
        )}
      </View>

      {starting && (
        <View style={styles.startingOverlay}>
          <ActivityIndicator color={COLORS.gold} size="large" />
          <Text style={styles.startingText}>Starting…</Text>
        </View>
      )}

      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

        {/* Step 1: League picker */}
        {step === 'league' && leagues.map((league) => {
          const gradient = LEAGUE_GRADIENTS[league.slug] ?? ['#333', '#111']
          return (
            <TouchableOpacity key={league.id} onPress={() => handleLeagueSelect(league)} activeOpacity={0.85}>
              <LinearGradient colors={gradient} style={styles.leagueRow} start={{ x: 0, y: 0 }} end={{ x: 1, y: 1 }}>
                <Text style={styles.leagueName}>{LEAGUE_NAMES[league.slug] ?? league.name}</Text>
                <Text style={styles.leagueArrow}>›</Text>
              </LinearGradient>
            </TouchableOpacity>
          )
        })}

        {/* Step 2: Mode picker */}
        {step === 'mode' && MODES.map((m) => (
          <TouchableOpacity key={m.mode} onPress={() => handleModeSelect(m)} activeOpacity={0.8} style={styles.modeCard}>
            <Text style={styles.modeIcon}>{m.icon}</Text>
            <View style={styles.modeInfo}>
              <Text style={styles.modeLabel}>{m.label}</Text>
              <Text style={styles.modeDesc}>{m.desc}</Text>
            </View>
            <Text style={styles.modeArrow}>›</Text>
          </TouchableOpacity>
        ))}

        {/* Step 3: Category picker */}
        {step === 'category' && categories.map((cat, i) => {
          const locked = !profile?.is_premium && i >= FREE_CATEGORY_LIMIT
          return (
            <TouchableOpacity
              key={cat.id}
              onPress={() => !locked && handleCategorySelect(cat)}
              activeOpacity={locked ? 1 : 0.8}
              style={[styles.catCard, locked && styles.catLocked]}
            >
              <Text style={styles.catName}>{cat.name}</Text>
              {locked && (
                <View style={styles.lockPill}>
                  <Text style={styles.lockText}>Premium</Text>
                </View>
              )}
            </TouchableOpacity>
          )
        })}

      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 20, paddingBottom: 32 },

  header:   { paddingHorizontal: 20, paddingTop: 16, paddingBottom: 8 },
  backBtn:  { marginBottom: 4 },
  backText: { color: COLORS.textSecondary, fontSize: 15 },
  title:    { color: COLORS.textPrimary, fontSize: 26, fontWeight: '800', letterSpacing: -0.5 },
  subtitle: { color: COLORS.textMuted, fontSize: 14, marginTop: 2 },

  startingOverlay: {
    position:        'absolute',
    inset:           0,
    backgroundColor: 'rgba(8,11,20,0.85)',
    zIndex:          99,
    justifyContent:  'center',
    alignItems:      'center',
    gap:             12,
  },
  startingText: { color: COLORS.textSecondary, fontSize: 16 },

  leagueRow: {
    borderRadius:    16,
    padding:         20,
    marginBottom:    12,
    flexDirection:   'row',
    alignItems:      'center',
    justifyContent:  'space-between',
  },
  leagueName:  { color: '#fff', fontSize: 20, fontWeight: '800' },
  leagueArrow: { color: 'rgba(255,255,255,0.7)', fontSize: 24 },

  modeCard: {
    backgroundColor: COLORS.surface,
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         16,
    marginBottom:    10,
    flexDirection:   'row',
    alignItems:      'center',
    gap:             14,
  },
  modeIcon:  { fontSize: 28 },
  modeInfo:  { flex: 1 },
  modeLabel: { color: COLORS.textPrimary, fontSize: 16, fontWeight: '700' },
  modeDesc:  { color: COLORS.textMuted, fontSize: 13, marginTop: 2 },
  modeArrow: { color: COLORS.textMuted, fontSize: 22 },

  catCard: {
    backgroundColor: COLORS.surface,
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         18,
    marginBottom:    10,
    flexDirection:   'row',
    alignItems:      'center',
    justifyContent:  'space-between',
  },
  catLocked: { opacity: 0.5 },
  catName:   { color: COLORS.textPrimary, fontSize: 16, fontWeight: '600' },
  lockPill: {
    backgroundColor: 'rgba(245,197,24,0.15)',
    borderRadius:    8,
    paddingHorizontal: 10,
    paddingVertical:   3,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.3)',
  },
  lockText: { color: COLORS.gold, fontSize: 11, fontWeight: '700' },
})
