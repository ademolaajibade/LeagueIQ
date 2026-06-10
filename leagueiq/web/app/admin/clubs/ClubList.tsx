'use client'

import { useState, useTransition } from 'react'
import { deleteClub } from '../actions'
import ClubForm, { type ClubData } from './ClubForm'

interface League { id: string; name: string }
interface Club extends ClubData { leagues: { name: string } | null }

export default function ClubList({ clubs, leagues }: { clubs: Club[]; leagues: League[] }) {
  const [editing, setEditing] = useState<string | null>(null)
  const [isPending, startTransition] = useTransition()

  function handleDelete(id: string) {
    if (!confirm('Delete this club?')) return
    startTransition(() => deleteClub(id))
  }

  // Group by league
  const grouped: Record<string, { leagueName: string; clubs: Club[] }> = {}
  for (const club of clubs) {
    const name = club.leagues?.name ?? 'Unknown'
    if (!grouped[club.league_id]) grouped[club.league_id] = { leagueName: name, clubs: [] }
    grouped[club.league_id].clubs.push(club)
  }

  return (
    <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
      <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 16 }}>
        All Clubs ({clubs.length})
      </h2>

      {Object.values(grouped).map(group => (
        <div key={group.leagueName} style={{ marginBottom: 24 }}>
          <div style={{ color: '#7C3AED', fontSize: 13, fontWeight: 600, marginBottom: 10, textTransform: 'uppercase', letterSpacing: 1 }}>
            {group.leagueName}
          </div>
          {group.clubs.map(club => (
            <div key={club.id}>
              {editing === club.id ? (
                <div style={{ marginBottom: 12 }}>
                  <ClubForm
                    leagues={leagues}
                    editClub={club}
                    onCancel={() => setEditing(null)}
                  />
                </div>
              ) : (
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '10px 0', borderBottom: '1px solid rgba(255,255,255,0.04)' }}>
                  <span style={{ color: '#FFFFFF', fontSize: 14 }}>{club.name}</span>
                  <div style={{ display: 'flex', gap: 12 }}>
                    <button onClick={() => setEditing(club.id)} style={{ background: 'none', border: 'none', color: '#7C3AED', fontSize: 13, cursor: 'pointer', padding: 0 }}>Edit</button>
                    <button onClick={() => handleDelete(club.id)} disabled={isPending} style={{ background: 'none', border: 'none', color: '#EF4444', fontSize: 13, cursor: 'pointer', padding: 0 }}>Delete</button>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      ))}
    </div>
  )
}
