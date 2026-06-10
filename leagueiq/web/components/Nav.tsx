'use client'

import Link from 'next/link'
import { usePathname, useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'

const links = [
  { href: '/home',        label: 'Home',        icon: '🏠' },
  { href: '/play',        label: 'Play',         icon: '⚡' },
  { href: '/leaderboard', label: 'Leaderboard',  icon: '🏆' },
  { href: '/profile',     label: 'Profile',      icon: '👤' },
]

export default function Nav() {
  const pathname = usePathname()
  const router   = useRouter()

  async function signOut() {
    const supabase = createClient()
    await supabase.auth.signOut()
    router.push('/login')
  }

  return (
    <>
      {/* Desktop top nav */}
      <nav
        className="hidden md:flex items-center justify-between px-8 py-4 border-b sticky top-0 z-40"
        style={{ background: '#080B14', borderColor: 'rgba(255,255,255,0.08)' }}
      >
        <span className="text-white font-black text-xl tracking-tight">LeagueIQ</span>
        <div className="flex items-center gap-1">
          {links.map((l) => {
            const active = pathname === l.href || pathname.startsWith(l.href + '/')
            return (
              <Link
                key={l.href}
                href={l.href}
                className="px-4 py-2 rounded-lg text-sm font-semibold transition-colors"
                style={{
                  color:           active ? '#F5C518' : '#94A3B8',
                  backgroundColor: active ? 'rgba(245,197,24,0.1)' : 'transparent',
                }}
              >
                {l.label}
              </Link>
            )
          })}
        </div>
        <button
          onClick={signOut}
          className="text-sm font-semibold transition-colors"
          style={{ color: '#475569' }}
        >
          Sign out
        </button>
      </nav>

      {/* Mobile bottom tabs */}
      <nav
        className="md:hidden fixed bottom-0 left-0 right-0 z-40 border-t flex"
        style={{ background: '#080B14', borderColor: 'rgba(255,255,255,0.08)' }}
      >
        {links.map((l) => {
          const active = pathname === l.href || pathname.startsWith(l.href + '/')
          return (
            <Link
              key={l.href}
              href={l.href}
              className="flex-1 flex flex-col items-center gap-1 py-3 transition-colors"
              style={{ color: active ? '#F5C518' : '#475569' }}
            >
              <span className="text-lg leading-none">{l.icon}</span>
              <span className="text-[10px] font-semibold">{l.label}</span>
            </Link>
          )
        })}
      </nav>
    </>
  )
}
