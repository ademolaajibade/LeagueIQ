import { createAdminClient } from '@/lib/supabase/admin'
import QotdScheduler from './QotdScheduler'

export default async function QotdPage() {
  const admin = createAdminClient()

  const [{ data: entries }, { data: leagues }, { data: questions }] = await Promise.all([
    admin
      .from('question_of_the_day')
      .select('id, date, question_id, questions(question, league_id, leagues(name))')
      .order('date', { ascending: false })
      .limit(60),
    admin.from('leagues').select('id, name').order('name'),
    admin.from('questions').select('id, question, league_id').eq('is_active', true).order('question'),
  ])

  return (
    <div>
      <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700, marginBottom: 32 }}>Question of the Day</h1>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1.4fr', gap: 32 }}>
        <QotdScheduler leagues={leagues ?? []} questions={questions ?? []} />

        <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
          <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 16 }}>Scheduled Entries</h2>
          {(entries ?? []).length === 0 ? (
            <div style={{ color: '#475569', fontSize: 14 }}>No QOTD scheduled yet</div>
          ) : (entries ?? []).map(e => {
            const q = e.questions as { question: string; league_id: string; leagues: { name: string } | null } | null
            return (
              <div key={e.id} style={{ padding: '12px 0', borderBottom: '1px solid rgba(255,255,255,0.05)' }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                  <span style={{ color: '#F5C518', fontSize: 13, fontWeight: 600 }}>{e.date}</span>
                  <span style={{ color: '#94A3B8', fontSize: 12 }}>{q?.leagues?.name ?? '—'}</span>
                </div>
                <div style={{ color: '#FFFFFF', fontSize: 13, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                  {q?.question ?? e.question_id}
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
