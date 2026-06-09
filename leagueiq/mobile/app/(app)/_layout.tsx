import { Tabs } from 'expo-router'
import { Ionicons } from '@expo/vector-icons'
import { COLORS } from '../../lib/colors'

type IoniconsName = React.ComponentProps<typeof Ionicons>['name']

function tabIcon(focused: boolean, active: IoniconsName, inactive: IoniconsName) {
  return ({ color, size }: { color: string; size: number }) => (
    <Ionicons name={focused ? active : inactive} size={size} color={color} />
  )
}

export default function AppLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown:              false,
        tabBarStyle:              {
          backgroundColor:    COLORS.surface,
          borderTopColor:     COLORS.border,
          borderTopWidth:     1,
          paddingBottom:      4,
          height:             58,
        },
        tabBarActiveTintColor:   COLORS.gold,
        tabBarInactiveTintColor: COLORS.textMuted,
        tabBarLabelStyle:        { fontSize: 11, fontWeight: '600' },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title:       'Home',
          tabBarIcon:  ({ focused, color, size }) =>
            tabIcon(focused, 'home', 'home-outline')({ color, size }),
        }}
      />
      <Tabs.Screen
        name="play"
        options={{
          title:      'Play',
          tabBarIcon: ({ focused, color, size }) =>
            tabIcon(focused, 'football', 'football-outline')({ color, size }),
        }}
      />
      <Tabs.Screen
        name="leaderboard"
        options={{
          title:      'Rankings',
          tabBarIcon: ({ focused, color, size }) =>
            tabIcon(focused, 'trophy', 'trophy-outline')({ color, size }),
        }}
      />
      <Tabs.Screen
        name="profile"
        options={{
          title:      'Profile',
          tabBarIcon: ({ focused, color, size }) =>
            tabIcon(focused, 'person', 'person-outline')({ color, size }),
        }}
      />
    </Tabs>
  )
}
