import { useEffect, useState } from 'react'
import {
  View, Text, ScrollView, StyleSheet,
  TouchableOpacity, ActivityIndicator, Alert,
} from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useRouter } from 'expo-router'
import { useAuth } from '../../contexts/AuthContext'
import LevelBadge from '../../components/LevelBadge'
import StreakBadge from '../../components/StreakBadge'
import { COLORS, LEAGUE_NAMES, LEAGUE_COLORS } from '../../lib/colors'
import { getUserStats, fetchLeagues, fetchLeagueMastery, createPayment, verifyPayment, activateXpBooster } from '../../lib/api'
import type { League, LeagueMastery } from '../../types'
import { openBrowserAsync } from 'expo-web-browser'

interface Stats {
  games_played: number
  accuracy: number
  best_streak: number
  xp_total: number
}

export default function ProfileScreen() {
  const { profile, signOut, refreshProfile } = useAuth()
  const router = useRouter()

  const [stats,         setStats]         = useState<Stats | null>(null)
  const [leagues,       setLeagues]       = useState<League[]>([])
  const [mastery,       setMastery]       = useState<LeagueMastery[]>([])
  const [loading,       setLoading]       = useState(true)
  const [upgrading,     setUpgrading]     = useState(false)
  const [boosting,      setBoosting]      = useState(false)
  const [boosterExpiry, setBoosterExpiry] = useState<string | null>(null)

  useEffect(() => {
    if (!profile) return
    const expiry = (profile as unknown as { xp_booster_expires_at?: string | null }).xp_booster_expires_at ?? null
    setBoosterExpiry(expiry)
    Promise.all([
      getUserStats(),
      fetchLeagues(),
      fetchLeagueMastery(profile.id),
    ]).then(([s, ls, ms]) => {
      setStats(s)
      setLeagues(ls)
      setMastery(ms)
    }).finally(() => setLoading(false))
  }, [profile?.id])

  async function handleUpgrade(plan: 'monthly' | 'yearly') {
    setUpgrading(true)
    try {
      const { payment_url, reference } = await createPayment({ plan })
      await openBrowserAsync(payment_url)
      await verifyPayment({ reference })
      await refreshProfile()
      Alert.alert('Success', 'Premium activated!')
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Payment failed')
    } finally {
      setUpgrading(false)
    }
  }

  async function handleBooster() {
    setBoosting(true)
    try {
      const { xp_booster_expires_at } = await activateXpBooster()
      setBoosterExpiry(xp_booster_expires_at)
      Alert.alert('Activated!', '2× XP Booster is active for 24 hours.')
    } catch (e: unknown) {
      Alert.alert('Error', e instanceof Error ? e.message : 'Could not activate booster')
    } finally {
      setBoosting(false)
    }
  }

  function boosterLabel(): string {
    if (!boosterExpiry) return 'Not active'
    const remaining = new Date(boosterExpiry).getTime() - Date.now()
    if (remaining <= 0) return 'Expired'
    const hrs  = Math.floor(remaining / 3_600_000)
    const mins = Math.floor((remaining % 3_600_000) / 60_000)
    return hrs > 0 ? `Active · ${hrs}h ${mins}m left` : `Active · ${mins}m left`
  }

  function getMastery(leagueId: string) {
    return mastery.find((m) => m.league_id === leagueId)
  }

  const MASTERY_ORDER = ['Rookie', 'Fan', 'Expert', 'Ultras👑']

  if (!profile) return null

  return (
    <SafeAreaView style={styles.safe}>
      <ScrollView contentContainerStyle={styles.scroll} showsVerticalScrollIndicator={false}>

        {/* Avatar + Name */}
        <View style={styles.hero}>
          <View style={styles.avatar}>
            <Text style={styles.avatarInitial}>{profile.username[0]?.toUpperCase()}</Text>
          </View>
          <Text style={styles.username}>@{profile.username}</Text>
          <View style={styles.heroRow}>
            <StreakBadge streak={profile.streak} size="lg" />
          </View>
        </View>

        {/* Level + XP */}
        <View style={styles.card}>
          <LevelBadge level={profile.level} xp={profile.xp} showBar />
        </View>

        {/* Stats grid */}
        {loading ? (
          <ActivityIndicator color={COLORS.gold} style={{ marginVertical: 20 }} />
        ) : stats && (
          <View style={styles.statsGrid}>
            {[
              { label: 'Games',    value: stats.games_played },
              { label: 'Accuracy', value: `${stats.accuracy}%` },
              { label: 'Streak',   value: stats.best_streak },
              { label: 'XP',       value: stats.xp_total.toLocaleString() },
            ].map((s) => (
              <View key={s.label} style={styles.statCell}>
                <Text style={styles.statValue}>{s.value}</Text>
                <Text style={styles.statLabel}>{s.label}</Text>
              </View>
            ))}
          </View>
        )}

        {/* League mastery */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>League Mastery</Text>
          {leagues.map((league) => {
            const m = getMastery(league.id)
            const level  = m?.mastery_level ?? 'Rookie'
            const cats   = m?.categories_completed ?? 0
            const pct    = (cats / 7) * 100
            const accent = LEAGUE_COLORS[league.slug] ?? COLORS.gold
            return (
              <View key={league.id} style={styles.masteryRow}>
                <View style={styles.masteryLeft}>
                  <Text style={styles.masteryLeague}>{LEAGUE_NAMES[league.slug]}</Text>
                  <Text style={styles.masteryLevel}>{level}</Text>
                </View>
                <View style={styles.masteryRight}>
                  <View style={styles.masteryBarBg}>
                    <View style={[styles.masteryBarFill, { width: `${pct}%` as `${number}%`, backgroundColor: accent }]} />
                  </View>
                  <Text style={styles.masteryCount}>{cats}/7</Text>
                </View>
              </View>
            )
          })}
        </View>

        {/* XP Booster — premium only */}
        {profile.is_premium && (
          <View style={styles.boosterCard}>
            <View style={styles.boosterHeader}>
              <Text style={styles.boosterTitle}>⚡ XP Booster</Text>
              <Text style={[
                styles.boosterStatus,
                { color: boosterExpiry && new Date(boosterExpiry) > new Date() ? '#22c55e' : COLORS.textMuted },
              ]}>
                {boosterLabel()}
              </Text>
            </View>
            <TouchableOpacity
              style={[
                styles.premiumBtn,
                styles.premiumBtnPrimary,
                (boosting || (boosterExpiry ? new Date(boosterExpiry) > new Date() : false)) && styles.btnDisabled,
              ]}
              onPress={handleBooster}
              disabled={boosting || (boosterExpiry ? new Date(boosterExpiry) > new Date() : false)}
              activeOpacity={0.8}
            >
              <Text style={[styles.premiumBtnText, styles.premiumBtnTextPrimary]}>
                {boosting ? 'Activating…' : boosterExpiry && new Date(boosterExpiry) > new Date() ? 'Already Active' : 'Activate 2× XP (24h)'}
              </Text>
            </TouchableOpacity>
          </View>
        )}

        {/* Premium upgrade */}
        {!profile.is_premium && (
          <View style={styles.premiumCard}>
            <Text style={styles.premiumTitle}>Go Premium ⭐</Text>
            <Text style={styles.premiumSub}>Unlock all categories, streak shields, 2× XP booster & more</Text>
            <View style={styles.premiumBtns}>
              <TouchableOpacity
                style={styles.premiumBtn}
                onPress={() => handleUpgrade('monthly')}
                activeOpacity={0.8}
                disabled={upgrading}
              >
                <Text style={styles.premiumBtnText}>₦2,000 / mo</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={[styles.premiumBtn, styles.premiumBtnPrimary]}
                onPress={() => handleUpgrade('yearly')}
                activeOpacity={0.8}
                disabled={upgrading}
              >
                <Text style={[styles.premiumBtnText, styles.premiumBtnTextPrimary]}>
                  ₦18,000 / yr · Save 25%
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        )}

        {profile.is_premium && (
          <View style={styles.premiumActiveBadge}>
            <Text style={styles.premiumActiveText}>⭐ Premium Active</Text>
          </View>
        )}

        {/* Sign out */}
        <TouchableOpacity style={styles.signOutBtn} onPress={signOut} activeOpacity={0.7}>
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>

      </ScrollView>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  safe:   { flex: 1, backgroundColor: COLORS.background },
  scroll: { padding: 20, paddingBottom: 40 },

  hero: { alignItems: 'center', marginBottom: 24 },
  avatar: {
    width:           72,
    height:          72,
    borderRadius:    36,
    backgroundColor: COLORS.surfaceAlt,
    borderWidth:     2,
    borderColor:     COLORS.gold,
    justifyContent:  'center',
    alignItems:      'center',
    marginBottom:    10,
  },
  avatarInitial: { color: COLORS.gold, fontSize: 28, fontWeight: '800' },
  username:      { color: COLORS.textPrimary, fontSize: 22, fontWeight: '800', marginBottom: 8 },
  heroRow:       { marginTop: 4 },

  card: {
    backgroundColor: COLORS.surface,
    borderRadius:    16,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         16,
    marginBottom:    16,
  },

  statsGrid: {
    flexDirection:  'row',
    flexWrap:       'wrap',
    gap:            10,
    marginBottom:   24,
  },
  statCell: {
    flex:            1,
    minWidth:        '45%',
    backgroundColor: COLORS.surface,
    borderRadius:    14,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         16,
    alignItems:      'center',
  },
  statValue: { color: COLORS.textPrimary, fontSize: 24, fontWeight: '800' },
  statLabel: { color: COLORS.textMuted, fontSize: 12, marginTop: 4 },

  section:      { marginBottom: 24 },
  sectionTitle: {
    color:         COLORS.textSecondary,
    fontSize:      13,
    fontWeight:    '700',
    letterSpacing: 1,
    textTransform: 'uppercase',
    marginBottom:  12,
  },

  masteryRow: {
    flexDirection:   'row',
    alignItems:      'center',
    backgroundColor: COLORS.surface,
    borderRadius:    12,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         14,
    marginBottom:    8,
    gap:             12,
  },
  masteryLeft:     { width: 110 },
  masteryLeague:   { color: COLORS.textPrimary, fontSize: 14, fontWeight: '700' },
  masteryLevel:    { color: COLORS.textMuted, fontSize: 12, marginTop: 2 },
  masteryRight:    { flex: 1, gap: 4 },
  masteryBarBg: {
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderRadius:    4,
    height:          6,
    overflow:        'hidden',
  },
  masteryBarFill:  { height: 6, borderRadius: 4 },
  masteryCount:    { color: COLORS.textMuted, fontSize: 11 },

  boosterCard: {
    backgroundColor: COLORS.surface,
    borderRadius:    16,
    borderWidth:     1,
    borderColor:     COLORS.border,
    padding:         20,
    marginBottom:    16,
    gap:             12,
  },
  boosterHeader: { gap: 4 },
  boosterTitle:  { color: COLORS.textPrimary, fontSize: 16, fontWeight: '800' },
  boosterStatus: { fontSize: 13, fontWeight: '600' },
  btnDisabled:   { opacity: 0.4 },

  premiumCard: {
    backgroundColor: 'rgba(245,197,24,0.06)',
    borderRadius:    16,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.25)',
    padding:         20,
    marginBottom:    16,
  },
  premiumTitle:    { color: COLORS.gold, fontSize: 18, fontWeight: '800', marginBottom: 6 },
  premiumSub:      { color: COLORS.textSecondary, fontSize: 13, lineHeight: 18, marginBottom: 16 },
  premiumBtns:     { gap: 10 },
  premiumBtn: {
    borderRadius:    12,
    borderWidth:     1,
    borderColor:     COLORS.gold,
    paddingVertical: 12,
    alignItems:      'center',
  },
  premiumBtnPrimary:     { backgroundColor: COLORS.gold },
  premiumBtnText:        { color: COLORS.gold, fontWeight: '700', fontSize: 15 },
  premiumBtnTextPrimary: { color: '#000' },

  premiumActiveBadge: {
    backgroundColor: 'rgba(245,197,24,0.1)',
    borderRadius:    12,
    padding:         14,
    alignItems:      'center',
    marginBottom:    16,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.25)',
  },
  premiumActiveText: { color: COLORS.gold, fontWeight: '700', fontSize: 15 },

  signOutBtn: {
    borderRadius:    12,
    borderWidth:     1,
    borderColor:     COLORS.border,
    paddingVertical: 14,
    alignItems:      'center',
  },
  signOutText: { color: COLORS.textMuted, fontWeight: '600', fontSize: 15 },
})
