import * as Notifications from 'expo-notifications'
import Constants from 'expo-constants'
import { Platform } from 'react-native'
import { registerPushToken } from './api'

// Show notifications even when the app is in the foreground
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge:  false,
  }),
})

export async function setupAndroidChannel(): Promise<void> {
  if (Platform.OS !== 'android') return
  await Notifications.setNotificationChannelAsync('default', {
    name:             'LeagueIQ',
    importance:       Notifications.AndroidImportance.HIGH,
    vibrationPattern: [0, 250, 250, 250],
    lightColor:       '#F5C518',
  })
}

export async function registerForPushNotificationsAsync(): Promise<string | null> {
  // Physical device required — emulators can't receive push
  const isDevice = Constants.isDevice ?? true
  if (!isDevice) return null

  const { status: existingStatus } = await Notifications.getPermissionsAsync()
  let finalStatus = existingStatus

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync()
    finalStatus = status
  }

  if (finalStatus !== 'granted') return null

  try {
    const projectId: string | undefined =
      Constants.expoConfig?.extra?.eas?.projectId

    const tokenData = await Notifications.getExpoPushTokenAsync(
      projectId ? { projectId } : undefined,
    )
    const token = tokenData.data

    // Register with the backend (fire-and-forget — don't block the app)
    registerPushToken(token).catch(() => null)

    return token
  } catch {
    return null
  }
}

// ── Notification data types sent from the backend ────────────

export interface NotificationData {
  type:
    | 'daily_challenge'
    | 'streak_at_risk'
    | 'tournament_ending'
    | 'match_invite'
    | 'level_up'
  match_id?:       string
  tournament_id?:  string
  new_level?:      string
}

export function getRouteForNotification(data: NotificationData): string | null {
  switch (data.type) {
    case 'daily_challenge':
      return '/(app)/play'
    case 'streak_at_risk':
      return '/(app)/play'
    case 'tournament_ending':
      return '/(app)/play'
    case 'match_invite':
      return data.match_id ? `/match/${data.match_id}` : '/match/lobby'
    case 'level_up':
      return '/(app)/profile'
    default:
      return null
  }
}
