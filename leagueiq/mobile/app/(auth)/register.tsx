import { useState } from 'react'
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  KeyboardAvoidingView, Platform, ActivityIndicator, Alert, ScrollView,
} from 'react-native'
import { Link } from 'expo-router'
import { supabase } from '../../lib/supabase'

export default function RegisterScreen() {
  const [email, setEmail]       = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm]   = useState('')
  const [loading, setLoading]   = useState(false)
  const [sent, setSent]         = useState(false)

  const signUp = async () => {
    if (!email.trim() || !password || !confirm) {
      Alert.alert('Error', 'Please fill in all fields.')
      return
    }
    if (password !== confirm) {
      Alert.alert('Error', 'Passwords do not match.')
      return
    }
    if (password.length < 8) {
      Alert.alert('Error', 'Password must be at least 8 characters.')
      return
    }

    setLoading(true)
    const { error } = await supabase.auth.signUp({ email: email.trim(), password })
    setLoading(false)

    if (error) {
      Alert.alert('Sign Up Failed', error.message)
    } else {
      setSent(true)
    }
  }

  if (sent) {
    return (
      <View style={[styles.container, { justifyContent: 'center', paddingHorizontal: 28 }]}>
        <Text style={styles.title}>Check your inbox</Text>
        <Text style={styles.sentBody}>
          We sent a confirmation link to{'\n'}
          <Text style={{ color: '#00e5a0', fontWeight: '600' }}>{email}</Text>
        </Text>
        <Text style={styles.sentSub}>
          Click the link to verify your account, then come back and sign in.
        </Text>
        <Link href="/(auth)/login" asChild>
          <TouchableOpacity style={styles.btn}>
            <Text style={styles.btnText}>Back to Sign In</Text>
          </TouchableOpacity>
        </Link>
      </View>
    )
  }

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView
        contentContainerStyle={styles.inner}
        keyboardShouldPersistTaps="handled"
      >
        <Text style={styles.title}>Create account</Text>
        <Text style={styles.subtitle}>Join the LeagueIQ community</Text>

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
          placeholder="Password (min 8 characters)"
          placeholderTextColor="#555"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          editable={!loading}
        />
        <TextInput
          style={styles.input}
          placeholder="Confirm password"
          placeholderTextColor="#555"
          value={confirm}
          onChangeText={setConfirm}
          secureTextEntry
          editable={!loading}
        />

        <TouchableOpacity style={styles.btn} onPress={signUp} disabled={loading}>
          {loading
            ? <ActivityIndicator color="#000" />
            : <Text style={styles.btnText}>Create Account</Text>
          }
        </TouchableOpacity>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Already have an account? </Text>
          <Link href="/(auth)/login" asChild>
            <TouchableOpacity>
              <Text style={styles.link}>Sign in</Text>
            </TouchableOpacity>
          </Link>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a0a' },
  inner: {
    flexGrow:          1,
    justifyContent:    'center',
    paddingHorizontal: 28,
    paddingVertical:   40,
  },
  title:    { fontSize: 32, fontWeight: '800', color: '#fff', marginBottom: 6, letterSpacing: -0.5 },
  subtitle: { color: '#888', marginBottom: 32, fontSize: 15 },
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
  btnText:    { color: '#000', fontWeight: '700', fontSize: 16 },
  footer: {
    flexDirection:  'row',
    justifyContent: 'center',
    marginTop:      28,
  },
  footerText: { color: '#555', fontSize: 14 },
  link:       { color: '#00e5a0', fontWeight: '600', fontSize: 14 },
  sentBody: {
    color:        '#aaa',
    fontSize:     16,
    textAlign:    'center',
    lineHeight:   24,
    marginBottom: 12,
  },
  sentSub: {
    color:        '#555',
    fontSize:     14,
    textAlign:    'center',
    marginBottom: 32,
    lineHeight:   20,
  },
})
