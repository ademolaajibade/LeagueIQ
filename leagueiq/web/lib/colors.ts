export const COLORS = {
  background:    '#080B14',
  surface:       '#111827',
  surfaceAlt:    '#1A2235',
  border:        'rgba(255,255,255,0.08)',
  textPrimary:   '#FFFFFF',
  textSecondary: '#94A3B8',
  textMuted:     '#475569',
  gold:          '#F5C518',
  success:       '#22C55E',
  error:         '#EF4444',
} as const

export const LEAGUE_COLORS: Record<string, string> = {
  epl:        '#7C3AED',
  la_liga:    '#EF4444',
  serie_a:    '#3B82F6',
  bundesliga: '#EF4444',
  ligue_1:    '#1D4ED8',
}

export const LEAGUE_GRADIENTS: Record<string, [string, string]> = {
  epl:        ['#7C3AED', '#4C1D95'],
  la_liga:    ['#EF4444', '#991B1B'],
  serie_a:    ['#3B82F6', '#1E3A8A'],
  bundesliga: ['#EF4444', '#92400E'],
  ligue_1:    ['#1D4ED8', '#1E3A8A'],
}

export const LEAGUE_NAMES: Record<string, string> = {
  epl:        'Premier League',
  la_liga:    'La Liga',
  serie_a:    'Serie A',
  bundesliga: 'Bundesliga',
  ligue_1:    'Ligue 1',
}

export const LEVEL_COLORS: Record<string, string> = {
  Bronze:   '#CD7F32',
  Silver:   '#C0C0C0',
  Gold:     '#F5C518',
  Platinum: '#E5E4E2',
  Legend:   '#FF6B35',
}
