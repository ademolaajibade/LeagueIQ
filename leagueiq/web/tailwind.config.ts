import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './store/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        iq: {
          bg:      '#080B14',
          surface: '#111827',
          alt:     '#1A2235',
          border:  'rgba(255,255,255,0.08)',
          gold:    '#F5C518',
          success: '#22C55E',
          error:   '#EF4444',
          muted:   '#475569',
          sub:     '#94A3B8',
        },
      },
    },
  },
  plugins: [],
}

export default config
