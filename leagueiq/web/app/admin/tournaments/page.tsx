import { createAdminClient } from '@/lib/supabase/admin'
import TournamentForm from './TournamentForm'
import TournamentActions from './TournamentActions'

export default async function TournamentsPage() {
  const admin = createAdminClient()

  const [{ data: tournaments }, { data: leagues }] = await Promise.all([
    admin
      .from('tournaments')
      .select('id, league_id, starts_at, ends_at, status, leagues(name), tournament_entries(count)')
      .order('starts_at', { ascending: false })
      .limit(50),
    admin.from('leagues').select('id, name').order('name'),
  ])

  const statusColor = (s: string) =>
    s === 'active' ? '#22C55E' : s === 'upcoming' ? '#F5C518' : '#475569'

  return (
    <div>
      <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700, marginBottom: 32 }}>Tournaments</h1>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.6fr', gap: 32 }}>
        <TournamentForm leagues={leagues ?? []} />

        <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
          <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 16 }}>All Tournaments</h2>

          {(tournaments ?? []).length === 0 ? (
            <div style={{ color: '#475569', fontSize: 14 }}>No tournaments yet</div>
          ) : (tournaments ?? []).map(t => {
            const leagueName = (t.leagues as { name: string } | null)?.name ?? '—'
            const entries    = (t.tournament_entries as { count: number }[] | null)?.[0]?.count ?? 0
            return (
              <div key={t.id} style={{ padding: '14px 0', borderBottom: '1px solid rgba(255,255,255,0.05)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 6 }}>
                  <div>
                    <span style={{ color: '#FFFFFF', fontSize: 14, fontWeight: 600 }}>{leagueName}</span>
                    <span style={{ color: '#94A3B8', fontSize: 12, marginLeft: 12 }}>{entries} entries</span>
                  </div>
                  <span style={{ color: statusColor(t.status), fontSize: 12, fontWeight: 600, textTransform: 'capitalize', background: `${statusColor(t.status)}1a`, padding: '2px 8px', borderRadius: 12 }}>
                    {t.status}
                  </span>
                </div>
                <div style={{ color: '#94A3B8', fontSize: 12, marginBottom: 8 }}>
                  {new Date(t.starts_at).toLocaleDateString()} → {new Date(t.ends_at).toLocaleDateString()}
                </div>
                <TournamentActions id={t.id} status={t.status} />
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
