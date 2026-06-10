import { createAdminClient } from '@/lib/supabase/admin'
import ClubForm from './ClubForm'
import ClubList from './ClubList'

export default async function ClubsPage() {
  const admin = createAdminClient()

  const [{ data: clubs }, { data: leagues }] = await Promise.all([
    admin.from('clubs').select('id, name, crest_url, league_id, leagues(name)').order('name'),
    admin.from('leagues').select('id, name').order('name'),
  ])

  return (
    <div>
      <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700, marginBottom: 32 }}>Clubs</h1>

      <div style={{ display: 'grid', gridTemplateColumns: '320px 1fr', gap: 32 }}>
        <ClubForm leagues={leagues ?? []} />
        <ClubList clubs={clubs ?? []} leagues={leagues ?? []} />
      </div>
    </div>
  )
}
