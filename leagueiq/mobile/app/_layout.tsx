import { useEffect } from 'react'
import { Slot, useRouter, useSegments } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import { AuthProvider, useAuth } from '../contexts/AuthContext'

function InitialLayout() {
  const { session, profile, loading } = useAuth()
  const router = useRouter()
  const segments = useSegments()

  useEffect(() => {
    if (loading) return

    const inAuth = segments[0] === '(auth)'

    if (!session) {
      if (!inAuth) router.replace('/(auth)/login')
      return
    }

    if (!profile) return

    if (!profile.onboarding_completed) {
      if (segments[1] !== 'onboarding') router.replace('/(auth)/onboarding')
    } else if (inAuth) {
      router.replace('/(app)/')
    }
  }, [session, profile, loading])

  return <Slot />
}

export default function RootLayout() {
  return (
    <AuthProvider>
      <StatusBar style="light" />
      <InitialLayout />
    </AuthProvider>
  )
}
