import { createAdminClient } from '@/lib/supabase/admin'
import UserActions from './UserActions'

interface SearchParams { q?: string; page?: string }
const PAGE_SIZE = 40

export default async function UsersPage({ searchParams }: { searchParams: Promise<SearchParams> }) {
  const sp    = await searchParams
  const admin = createAdminClient()
  const page  = Number(sp.page ?? 1)
  const from  = (page - 1) * PAGE_SIZE
  const to    = from + PAGE_SIZE - 1

  let query = admin
    .from('profiles')
    .select('id, username, level, is_premium, role, is_banned, created_at', { count: 'exact' })
    .order('created_at', { ascending: false })
    .range(from, to)

  if (sp.q) query = query.ilike('username', `%${sp.q}%`)

  const { data: users, count } = await query
  const totalPages = Math.ceil((count ?? 0) / PAGE_SIZE)

  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24 }}>
        <h1 style={{ color: '#FFFFFF', fontSize: 28, fontWeight: 700 }}>Users</h1>
        <span style={{ color: '#475569', fontSize: 14 }}>{count ?? 0} total</span>
      </div>

      <form method="get" style={{ marginBottom: 20 }}>
        <div style={{ display: 'flex', gap: 12 }}>
          <input
            name="q"
            defaultValue={sp.q ?? ''}
            placeholder="Search by username…"
            style={{ flex: 1, maxWidth: 300, background: '#1A2235', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, color: '#FFFFFF', fontSize: 14, padding: '8px 14px' }}
          />
          <button type="submit" style={{ background: '#7C3AED', color: '#FFFFFF', border: 'none', borderRadius: 8, padding: '8px 18px', fontSize: 14, cursor: 'pointer' }}>
            Search
          </button>
        </div>
      </form>

      <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, overflow: 'hidden' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 80px 80px 70px 80px 120px', gap: 0, padding: '12px 20px', borderBottom: '1px solid rgba(255,255,255,0.08)' }}>
          {['Username', 'Level', 'Premium', 'Role', 'Status', 'Actions'].map(h => (
            <span key={h} style={{ color: '#475569', fontSize: 12, fontWeight: 600, textTransform: 'uppercase', letterSpacing: 1 }}>{h}</span>
          ))}
        </div>

        {(users ?? []).length === 0 ? (
          <div style={{ padding: 40, textAlign: 'center', color: '#475569' }}>No users found</div>
        ) : (users ?? []).map(u => (
          <div key={u.id} style={{ display: 'grid', gridTemplateColumns: '1fr 80px 80px 70px 80px 120px', gap: 0, padding: '12px 20px', borderBottom: '1px solid rgba(255,255,255,0.05)', alignItems: 'center' }}>
            <span style={{ color: u.is_banned ? '#475569' : '#FFFFFF', fontSize: 14 }}>
              {u.username}
              {u.is_banned && <span style={{ color: '#EF4444', fontSize: 11, marginLeft: 8, background: 'rgba(239,68,68,0.1)', padding: '1px 6px', borderRadius: 4 }}>banned</span>}
            </span>
            <span style={{ color: '#94A3B8', fontSize: 13 }}>{u.level}</span>
            <span style={{ color: u.is_premium ? '#F5C518' : '#475569', fontSize: 13 }}>{u.is_premium ? 'Yes' : 'No'}</span>
            <span style={{ color: u.role === 'admin' ? '#7C3AED' : '#94A3B8', fontSize: 13, fontWeight: u.role === 'admin' ? 600 : 400, textTransform: 'capitalize' }}>
              {u.role}
            </span>
            <span style={{ color: u.is_banned ? '#EF4444' : '#22C55E', fontSize: 13 }}>
              {u.is_banned ? 'Banned' : 'Active'}
            </span>
            <UserActions id={u.id} role={u.role} isBanned={u.is_banned} />
          </div>
        ))}
      </div>

      {totalPages > 1 && (
        <div style={{ display: 'flex', gap: 8, marginTop: 20, justifyContent: 'center' }}>
          {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
            <a
              key={p}
              href={`/admin/users?page=${p}${sp.q ? `&q=${sp.q}` : ''}`}
              style={{ padding: '6px 12px', borderRadius: 6, background: p === page ? '#7C3AED' : '#1A2235', color: '#FFFFFF', textDecoration: 'none', fontSize: 14 }}
            >
              {p}
            </a>
          ))}
        </div>
      )}
    </div>
  )
}
