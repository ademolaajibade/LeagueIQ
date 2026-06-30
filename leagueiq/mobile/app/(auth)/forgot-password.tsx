import { useState } from 'react'
import {
  View, Text, TextInput, TouchableOpacity, StyleSheet,
  KeyboardAvoidingView, Platform, ActivityIndicator, Alert,
} from 'react-native'
import { Link } from 'expo-router'
import { supabase } from '../../lib/supabase'

export default function ForgotPasswordScreen() {
  const [email, setEmail]     = useState('')
  const [loading, setLoading] = useState(false)
  const [sent, setSent]       = useState(false)

  const handleReset = async () => {
    if (!email.trim()) {
      Alert.alert('Error', 'Please enter your email address.')
      return
    }
    setLoading(true)
    const { error } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo: 'leagueiq://auth/callback',
    })
    setLoading(false)
    if (error) {
      Alert.alert('Error', error.message)
    } else {
      setSent(true)
    }
  }

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <View style={styles.inner}>
        <Text style={styles.title}>Reset Password</Text>
        <Text style={styles.subtitle}>
          Enter your email and we'll send you a link to reset your password.
        </Text>

        {sent ? (
          <View style={styles.sentBox}>
            <Text style={styles.sentTitle}>Check your email</Text>
            <Text style={styles.sentBody}>
              We sent a reset link to {email}. Follow it to set a new password.
            </Text>
          </View>
        ) : (
          <>
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
            <TouchableOpacity style={styles.btn} onPress={handleReset} disabled={loading}>
              {loading
                ? <ActivityIndicator color="#000" />
                : <Text style={styles.btnText}>Send Reset Link</Text>
              }
            </TouchableOpacity>
          </>
        )}

        <View style={styles.footer}>
          <Link href="/(auth)/login" asChild>
            <TouchableOpacity>
              <Text style={styles.link}>Back to Sign In</Text>
            </TouchableOpacity>
          </Link>
        </View>
      </View>
    </KeyboardAvoidingView>
  )
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#0a0a0a' },
  inner: {
    flex:              1,
    justifyContent:    'center',
    paddingHorizontal: 28,
    paddingBottom:     40,
  },
  title: {
    fontSize:      32,
    fontWeight:    '800',
    color:         '#fff',
    marginBottom:  10,
    letterSpacing: -0.5,
  },
  subtitle: {
    color:        '#888',
    marginBottom: 36,
    fontSize:     15,
    lineHeight:   22,
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
    backgroundColor: '#F5C518',
    borderRadius:    12,
    padding:         16,
    alignItems:      'center',
    marginTop:       4,
  },
  btnText: { color: '#000', fontWeight: '700', fontSize: 16 },
  sentBox: {
    backgroundColor: 'rgba(245,197,24,0.08)',
    borderRadius:    16,
    padding:         20,
    borderWidth:     1,
    borderColor:     'rgba(245,197,24,0.25)',
    marginBottom:    24,
  },
  sentTitle: { color: '#F5C518', fontSize: 17, fontWeight: '800', marginBottom: 8 },
  sentBody:  { color: '#888', fontSize: 14, lineHeight: 20 },
  footer: {
    flexDirection:  'row',
    justifyContent: 'center',
    marginTop:      28,
  },
  link: { color: '#F5C518', fontWeight: '600', fontSize: 14 },
})
