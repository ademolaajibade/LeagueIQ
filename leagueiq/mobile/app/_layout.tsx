import { useEffect, useRef } from 'react'
import { Stack, useRouter, useSegments } from 'expo-router'
import { StatusBar } from 'expo-status-bar'
import * as Notifications from 'expo-notifications'
import { AuthProvider, useAuth } from '../contexts/AuthContext'
import {
  setupAndroidChannel,
  getRouteForNotification,
  type NotificationData,
} from '../lib/notifications'

function InitialLayout() {
  const { session, profile, loading } = useAuth()
  const router = useRouter()
  const segments = useSegments() as string[]
  const responseListener = useRef<Notifications.EventSubscription>()

  // Set up Android notification channel once on mount
  useEffect(() => { setupAndroidChannel() }, [])

  // Handle notification tap — navigate to the relevant screen
  useEffect(() => {
    responseListener.current = Notifications.addNotificationResponseReceivedListener(
      (response) => {
        const data = response.notification.request.content.data as NotificationData
        const route = getRouteForNotification(data)
        if (route) router.push(route as never)
      },
    )

    // Check if app was launched from a tapped notification (cold start)
    Notifications.getLastNotificationResponseAsync().then((response) => {
      if (!response) return
      const data = response.notification.request.content.data as NotificationData
      const route = getRouteForNotification(data)
      if (route) router.push(route as never)
    })

    return () => { responseListener.current?.remove() }
  }, [])

  // Auth guard
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
      router.replace('/(app)')
    }
  }, [session, profile, loading])

  return (
    <Stack
      screenOptions={{
        headerShown:  false,
        contentStyle: { backgroundColor: '#080B14' },
        animation:    'slide_from_right',
      }}
    >
      <Stack.Screen name="(auth)" />
      <Stack.Screen name="(app)" />
      <Stack.Screen name="game"  options={{ animation: 'slide_from_bottom' }} />
      <Stack.Screen name="match" options={{ animation: 'slide_from_bottom' }} />
    </Stack>
  )
}

export default function RootLayout() {
  return (
    <AuthProvider>
      <StatusBar style="light" />
      <InitialLayout />
    </AuthProvider>
  )
}
