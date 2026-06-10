import Link from 'next/link'
import { createAdminClient } from '@/lib/supabase/admin'
import QuestionFilters from './QuestionFilters'
import { toggleQuestionActive } from '../actions'

const PAGE_SIZE = 30

interface SearchParams { league?: string; category?: string; difficulty?: string; q?: string; page?: string }

export default async function QuestionsPage({ searchParams }: { searchParams: Promise<SearchParams> }) {
  const sp    = await searchParams
  const admin = createAdminClient()
  const page  = Number(sp.page ?? 1)
  const from  = (page - 1) * PAGE_SIZE
  const to    = from + PAGE_SIZE - 1

  const [{ data: leagues }, { data: categories }] = await Promise.all([
    admin.from('leagues').select('id, name').order('name'),
    admin.from('categories').select('id, name, league_id').order('name'),
  ])

  let query = admin
    .from('questions')
    .select('id, question, difficulty, is_active, league_id, category_id, leagues(name), categories(name)', { count: 'exact' })
    .order('created_at', { ascending: false })
    .range(from, to)

  if (sp.league)     query = query.eq('league_id', sp.league)
  if (sp.category)   query = query.eq('category_id', sp.category)
  if (sp.difficulty) query = query.eq('difficulty', sp.difficulty)
  if (sp.q)          query = query.ilike('question', `%${sp.q}%`)

  const { data: questions, count } = await query
  const totalPages = Math.ceil((count ?? 0) / PAGE_SIZE)

  const diffColor = (d: string) =>
    d === 'easy' ? '#22C55E' : d === 'medium' ? '#F5C518' : '#EF4444'

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24 }}>
        <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700 }}>Questions</h1>
        <Link
          href="/admin/questions/new"
          style={{ background: '#7C3AED', color: '#FFFFFF', padding: '10px 20px', borderRadius: 8, textDecoration: 'none', fontSize: 14, fontWeight: 600 }}
        >
          + Add Question
        </Link>
      </div>

      <div style={{ marginBottom: 20 }}>
        <QuestionFilters leagues={leagues ?? []} categories={categories ?? []} />
      </div>

      <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, overflow: 'hidden' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 120px 120px 80px 100px', gap: 0, padding: '12px 20px', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
          {['Question', 'League', 'Category', 'Difficulty', 'Actions'].map(h => (
            <span key={h} style={{ color: '#475569', fontSize: 12, fontWeight: 600, textTransform: 'uppercase', letterSpacing: 1 }}>{h}</span>
          ))}
        </div>

        {(questions ?? []).length === 0 ? (
          <div style={{ padding: 40, textAlign: 'center', color: '#475569' }}>No questions found</div>
        ) : (questions ?? []).map(q => (
          <div key={q.id} style={{ display: 'grid', gridTemplateColumns: '1fr 120px 120px 80px 100px', gap: 0, padding: '14px 20px', borderBottom: '1px solid rgba(255,255,255,0.05)', alignItems: 'center' }}>
            <span style={{ color: q.is_active ? '#FFFFFF' : '#475569', fontSize: 14, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', paddingRight: 16 }}>
              {q.question}
            </span>
            <span style={{ color: '#94A3B8', fontSize: 13 }}>{(q.leagues as { name: string } | null)?.name ?? '—'}</span>
            <span style={{ color: '#94A3B8', fontSize: 13 }}>{(q.categories as { name: string } | null)?.name ?? '—'}</span>
            <span style={{ color: diffColor(q.difficulty), fontSize: 13, textTransform: 'capitalize' }}>{q.difficulty}</span>
            <div style={{ display: 'flex', gap: 8 }}>
              <Link
                href={`/admin/questions/${q.id}/edit`}
                style={{ color: '#7C3AED', fontSize: 13, textDecoration: 'none' }}
              >
                Edit
              </Link>
              <form action={toggleQuestionActive.bind(null, q.id, !q.is_active)}>
                <button type="submit" style={{ background: 'none', border: 'none', color: q.is_active ? '#EF4444' : '#22C55E', fontSize: 13, cursor: 'pointer', padding: 0 }}>
                  {q.is_active ? 'Hide' : 'Show'}
                </button>
              </form>
            </div>
          </div>
        ))}
      </div>

      {totalPages > 1 && (
        <div style={{ display: 'flex', gap: 8, marginTop: 20, justifyContent: 'center' }}>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
            <Link
              key={p}
              href={`/admin/questions?page=${p}${sp.league ? `&league=${sp.league}` : ''}${sp.difficulty ? `&difficulty=${sp.difficulty}` : ''}`}
              style={{
                padding: '6px 12px',
                borderRadius: 6,
                background: p === page ? '#7C3AED' : '#1A2235',
                color: '#FFFFFF',
                textDecoration: 'none',
                fontSize: 14,
              }}
            >
              {p}
            </Link>
          ))}
        </div>
      )}

      <div style={{ color: '#475569', fontSize: 13, marginTop: 12, textAlign: 'right' }}>
        {count ?? 0} total questions
      </div>
    </div>
  )
}
