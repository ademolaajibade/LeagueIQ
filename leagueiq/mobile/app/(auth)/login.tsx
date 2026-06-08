import { useState } from 'react'
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  KeyboardAvoidingView, Platform, ActivityIndicator, Alert,
} from 'react-native'
import { Link } from 'expo-router'
import * as WebBrowser from 'expo-web-browser'
import * as AuthSession from 'expo-auth-session'
import { supabase } from '../../lib/supabase'

WebBrowser.maybeCompleteAuthSession()

export default function LoginScreen() {
  const [email, setEmail]       = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading]   = useState(false)

  const signIn = async () => {
    if (!email.trim() || !password) {
      Alert.alert('Error', 'Please enter your email and password.')
      return
    }
    setLoading(true)
    const { error } = await supabase.auth.signInWithPassword({
      email: email.trim(),
      password,
    })
    setLoading(false)
    if (error) Alert.alert('Sign In Failed', error.message)
  }

  const signInWithGoogle = async () => {
    setLoading(true)
    const redirectTo = AuthSession.makeRedirectUri({ scheme: 'leagueiq', path: 'auth/callback' })

    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options:  { redirectTo, skipBrowserRedirect: true },
    })

    if (error || !data.url) {
      setLoading(false)
      Alert.alert('Google Sign In Failed', error?.message ?? 'Could not initiate sign in.')
      return
    }

    const result = await WebBrowser.openAuthSessionAsync(data.url, redirectTo)

    if (result.type === 'success' && result.url) {
      const url  = new URL(result.url)
      const code = url.searchParams.get('code')
      if (code) {
        const { error } = await supabase.auth.exchangeCodeForSession(code)
        if (error) Alert.alert('Sign In Failed', error.message)
      }
    }

    setLoading(false)
  }

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={styles.inner}>
        <Text style={styles.logo}>LeagueIQ</Text>
        <Text style={styles.subtitle}>Football Trivia. Your Leagues.</Text>

        <TextInput
          style={styles.input}
          placeholder="Email"
          placeholderTextColor="#555"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
          editable={!loading}
        />
        <TextInput
          style={styles.input}
          placeholder="Password"
          placeholderTextColor="#555"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          editable={!loading}
        />

        <TouchableOpacity style={styles.btn} onPress={signIn} disabled={loading}>
          {loading
            ? <ActivityIndicator color="#000" />
            : <Text style={styles.btnText}>Sign In</Text>
          }
        </TouchableOpacity>

        <View style={styles.dividerRow}>
          <View style={styles.divider} />
          <Text style={styles.dividerText}>or</Text>
          <View style={styles.divider} />
        </View>

        <TouchableOpacity style={styles.googleBtn} onPress={signInWithGoogle} disabled={loading}>
          <Text style={styles.googleBtnText}>Continue with Google</Text>
        </TouchableOpacity>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Don't have an account? </Text>
          <Link href="/(auth)/register" asChild>
            <TouchableOpacity>
              <Text style={styles.link}>Sign up</Text>
            </TouchableOpacity>
          </Link>
        </View>
      </View>
    </KeyboardAvoidingView>
  )
}

const styles = StyleSheet.create({
  container:     { flex: 1, backgroundColor: '#0a0a0a' },
  inner: {
    flex:             1,
    justifyContent:   'center',
    paddingHorizontal: 28,
    paddingBottom:    40,
  },
  logo: {
    fontSize:    40,
    fontWeight:  '800',
    color:       '#fff',
    textAlign:   'center',
    marginBottom: 6,
    letterSpacing: -1,
  },
  subtitle: {
    color:        '#888',
    textAlign:    'center',
    marginBottom: 40,
    fontSize:     15,
  },
  input: {
    backgroundColor: '#1a1a1a',
    borderRadius:    12,
    padding:         16,
    color:           '#fff',
    fontSize:        16,
    marginBottom:    12,
    borderWidth:     1,
    borderColor:     '#2a2a2a',
  },
  btn: {
    backgroundColor: '#00e5a0',
    borderRadius:    12,
    padding:         16,
    alignItems:      'center',
    marginTop:       4,
  },
  btnText:   { color: '#000', fontWeight: '700', fontSize: 16 },
  dividerRow: {
    flexDirection:  'row',
    alignItems:     'center',
    marginVertical: 20,
    gap:            12,
  },
  divider:     { flex: 1, height: 1, backgroundColor: '#2a2a2a' },
  dividerText: { color: '#555', fontSize: 13 },
  googleBtn: {
    backgroundColor: '#1a1a1a',
    borderRadius:    12,
    padding:         16,
    alignItems:      'center',
    borderWidth:     1,
    borderColor:     '#2a2a2a',
  },
  googleBtnText: { color: '#fff', fontWeight: '600', fontSize: 16 },
  footer: {
    flexDirection:  'row',
    justifyContent: 'center',
    marginTop:      28,
  },
  footerText: { color: '#555', fontSize: 14 },
  link:       { color: '#00e5a0', fontWeight: '600', fontSize: 14 },
})
