'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'

const NAV = [
  { label: 'Dashboard',          href: '/admin' },
  { label: 'Questions',          href: '/admin/questions' },
  { label: 'Question of the Day',href: '/admin/qotd' },
  { label: 'Tournaments',        href: '/admin/tournaments' },
  { label: 'Clubs',              href: '/admin/clubs' },
  { label: 'Users',              href: '/admin/users' },
]

export default function AdminSidebar() {
  const pathname = usePathname()

  return (
    <aside style={{
      width: 220,
      background: '#111827',
      borderRight: '1px solid rgba(255,255,255,0.08)',
      display: 'flex',
      flexDirection: 'column',
      minHeight: '100vh',
      position: 'sticky',
      top: 0,
    }}>
      <div style={{ padding: '24px 20px', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
        <div style={{ color: '#7C3AED', fontWeight: 700, fontSize: 18 }}>LeagueIQ</div>
        <div style={{ color: '#94A3B8', fontSize: 12, marginTop: 4 }}>Admin Panel</div>
      </div>

      <nav style={{ padding: '16px 12px', flex: 1 }}>
        {NAV.map(item => {
          const active = item.href === '/admin'
            ? pathname === '/admin'
            : pathname.startsWith(item.href)
          return (
            <Link
              key={item.href}
              href={item.href}
              style={{
                display: 'block',
                padding: '10px 12px',
                borderRadius: 8,
                color: active ? '#FFFFFF' : '#94A3B8',
                background: active ? 'rgba(124,58,237,0.15)' : 'transparent',
                borderLeft: `3px solid ${active ? '#7C3AED' : 'transparent'}`,
                textDecoration: 'none',
                fontSize: 14,
                marginBottom: 4,
                fontWeight: active ? 600 : 400,
              }}
            >
              {item.label}
            </Link>
          )
        })}
      </nav>

      <div style={{ padding: '16px 20px', borderTop: '1px solid rgba(255,255,255,0.08)' }}>
        <Link href="/home" style={{ color: '#475569', fontSize: 13, textDecoration: 'none' }}>
          ← Back to App
        </Link>
      </div>
    </aside>
  )
}
