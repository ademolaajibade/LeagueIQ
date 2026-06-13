import { createAdminClient } from '@/lib/supabase/admin'

function StatCard({ title, value, accent = '#FFFFFF' }: { title: string; value: number | string; accent?: string }) {
  return (
    <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: '20px 24px' }}>
      <div style={{ color: '#94A3B8', fontSize: 13, marginBottom: 8 }}>{title}</div>
      <div style={{ color: accent, fontSize: 32, fontWeight: 700 }}>{value}</div>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
      <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 16 }}>{title}</h2>
      {children}
    </div>
  )
}

function Row({ label, value }: { label: string; value: number | string }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 0', borderBottom: '1px solid rgba(255,255,255,0.05)' }}>
      <span style={{ color: '#94A3B8', fontSize: 14 }}>{label}</span>
      <span style={{ color: '#FFFFFF', fontSize: 14, fontWeight: 600 }}>{value}</span>
    </div>
  )
}

export default async function AdminDashboard() {
  const admin = createAdminClient()
  const DAY_MS  = 86_400_000
  const WEEK_MS = 7 * DAY_MS
  const now = Date.now()

  const [
    { count: totalUsers },
    { count: premiumUsers },
    { count: totalQuestions },
    { data: dauRows },
    { data: questionLeagueRows },
    { data: sessionLeagueRows },
    { data: recentUsers },
  ] = await Promise.all([
    admin.from('profiles').select('*', { count: 'exact', head: true }),
    admin.from('profiles').select('*', { count: 'exact', head: true }).eq('is_premium', true),
    admin.from('questions').select('*', { count: 'exact', head: true }).eq('is_active', true),
    admin.from('game_sessions').select('user_id').gte('started_at', new Date(now - DAY_MS).toISOString()),
    admin.from('questions').select('league_id, leagues(name)').eq('is_active', true),
    admin.from('game_sessions').select('league_id, leagues(name)').gte('started_at', new Date(now - WEEK_MS).toISOString()),
    admin.from('profiles').select('username, level, is_premium, created_at').order('created_at', { ascending: false }).limit(5),
  ])

  const dau = new Set((dauRows ?? []).map(r => r.user_id)).size

  // Aggregate questions per league
  const qByLeague: Record<string, { name: string; count: number }> = {}
  for (const q of questionLeagueRows ?? []) {
    const name = (q.leagues as unknown as { name: string } | null)?.name ?? 'Unknown'
    if (!qByLeague[q.league_id]) qByLeague[q.league_id] = { name, count: 0 }
    qByLeague[q.league_id].count++
  }

  // Aggregate sessions per league (last 7d)
  const sByLeague: Record<string, { name: string; count: number }> = {}
  for (const s of sessionLeagueRows ?? []) {
    const name = (s.leagues as unknown as { name: string } | null)?.name ?? 'Unknown'
    if (!sByLeague[s.league_id]) sByLeague[s.league_id] = { name, count: 0 }
    sByLeague[s.league_id].count++
  }
  const topLeagues = Object.values(sByLeague).sort((a, b) => b.count - a.count)

  return (
    <div>
      <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700, marginBottom: 32 }}>Dashboard</h1>

      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 16, marginBottom: 32 }}>
        <StatCard title="Total Users"       value={totalUsers ?? 0} />
        <StatCard title="Premium Users"     value={premiumUsers ?? 0} accent="#F5C518" />
        <StatCard title="DAU (24h)"         value={dau}              accent="#22C55E" />
        <StatCard title="Active Questions"  value={totalQuestions ?? 0} accent="#7C3AED" />
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 24, marginBottom: 32 }}>
        <Section title="Questions per League">
          {Object.values(qByLeague).length === 0
            ? <div style={{ color: '#475569', fontSize: 14 }}>No data</div>
            : Object.values(qByLeague).map(l => <Row key={l.name} label={l.name} value={l.count} />)
          }
        </Section>

        <Section title="Top Leagues — Last 7 Days">
          {topLeagues.length === 0
            ? <div style={{ color: '#475569', fontSize: 14 }}>No sessions yet</div>
            : topLeagues.map(l => <Row key={l.name} label={l.name} value={`${l.count} games`} />)
          }
        </Section>
      </div>

      <Section title="Recent Sign-ups">
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 80px 80px 160px', gap: 8, marginBottom: 8, padding: '0 4px' }}>
          {['Username', 'Level', 'Premium', 'Joined'].map(h => (
            <span key={h} style={{ color: '#475569', fontSize: 12, fontWeight: 600, textTransform: 'uppercase', letterSpacing: 1 }}>{h}</span>
          ))}
        </div>
        {(recentUsers ?? []).map(u => (
          <div key={u.username} style={{ display: 'grid', gridTemplateColumns: '1fr 80px 80px 160px', gap: 8, padding: '10px 4px', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
            <span style={{ color: '#FFFFFF', fontSize: 14 }}>{u.username}</span>
            <span style={{ color: '#94A3B8', fontSize: 14 }}>{u.level}</span>
            <span style={{ color: u.is_premium ? '#F5C518' : '#475569', fontSize: 14 }}>{u.is_premium ? 'Yes' : 'No'}</span>
            <span style={{ color: '#475569', fontSize: 14 }}>{new Date(u.created_at).toLocaleDateString()}</span>
          </div>
        ))}
      </Section>
    </div>
  )
}
