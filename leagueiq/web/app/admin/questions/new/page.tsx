import Link from 'next/link'
import { createAdminClient } from '@/lib/supabase/admin'
import QuestionForm from '../QuestionForm'

export default async function NewQuestionPage() {
  const admin = createAdminClient()
  const [{ data: leagues }, { data: categories }] = await Promise.all([
    admin.from('leagues').select('id, name').order('name'),
    admin.from('categories').select('id, name, league_id').order('name'),
  ])

  return (
    <div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 32 }}>
        <Link href="/admin/questions" style={{ color: '#475569', textDecoration: 'none', fontSize: 14 }}>← Questions</Link>
        <span style={{ color: '#475569' }}>/</span>
        <h1 style={{ color: '#FFFFFF', fontSize: 24, fontWeight: 700, margin: 0 }}>New Question</h1>
      </div>

      <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 32, maxWidth: 800 }}>
        <QuestionForm leagues={leagues ?? []} categories={categories ?? []} />
      </div>
    </div>
  )
}
