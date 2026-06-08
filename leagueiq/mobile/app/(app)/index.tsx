import { View, Text, TouchableOpacity, StyleSheet } from 'react-native'
import { SafeAreaView } from 'react-native-safe-area-context'
import { useAuth } from '../../contexts/AuthContext'

export default function HomeScreen() {
  const { profile, signOut } = useAuth()

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.inner}>
        <Text style={styles.title}>Welcome back,</Text>
        <Text style={styles.username}>@{profile?.username}</Text>
        <Text style={styles.sub}>
          Phase 3 complete — auth and onboarding are live.{'\n'}
          The full game UI arrives in Phase 5.
        </Text>

        <TouchableOpacity style={styles.signOutBtn} onPress={signOut}>
          <Text style={styles.signOutText}>Sign Out</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a0a' },
  inner: {
    flex:              1,
    justifyContent:    'center',
    alignItems:        'center',
    paddingHorizontal: 32,
  },
  title:    { color: '#888', fontSize: 16, marginBottom: 4 },
  username: { color: '#fff', fontSize: 32, fontWeight: '800', marginBottom: 20, letterSpacing: -0.5 },
  sub: {
    color:        '#555',
    textAlign:    'center',
    lineHeight:   22,
    fontSize:     14,
    marginBottom: 48,
  },
  signOutBtn: {
    borderRadius:    10,
    borderWidth:     1,
    borderColor:     '#2a2a2a',
    paddingVertical: 12,
    paddingHorizontal: 28,
  },
  signOutText: { color: '#888', fontWeight: '600', fontSize: 14 },
})
