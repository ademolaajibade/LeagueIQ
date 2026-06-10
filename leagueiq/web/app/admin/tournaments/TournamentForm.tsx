'use client'

import { useState, useTransition } from 'react'
import { createTournament } from '../actions'

interface League { id: string; name: string }

const inputStyle: React.CSSProperties = {
  width: '100%',
  background: '#1A2235',
  border: '1px solid rgba(255,255,255,0.1)',
  borderRadius: 8,
  color: '#FFFFFF',
  fontSize: 14,
  padding: '10px 14px',
  boxSizing: 'border-box',
}

const labelStyle: React.CSSProperties = {
  display: 'block',
  color: '#94A3B8',
  fontSize: 13,
  marginBottom: 6,
  fontWeight: 500,
}

export default function TournamentForm({ leagues }: { leagues: League[] }) {
  const [isPending, startTransition] = useTransition()
  const [error,    setError]    = useState<string | null>(null)
  const [success,  setSuccess]  = useState(false)

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError(null)
    setSuccess(false)
    const formData = new FormData(e.currentTarget)
    startTransition(async () => {
      const result = await createTournament(formData)
      if (result?.error) setError(result.error)
      else { setSuccess(true); (e.target as HTMLFormElement).reset() }
    })
  }

  return (
    <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
      <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 20 }}>Create Tournament</h2>
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 16 }}>
          <label style={labelStyle}>League *</label>
          <select name="league_id" required style={inputStyle}>
            <option value="">Select league…</option>
            {leagues.map(l => <option key={l.id} value={l.id}>{l.name}</option>)}
          </select>
        </div>

        <div style={{ marginBottom: 16 }}>
          <label style={labelStyle}>Start Date & Time *</label>
          <input type="datetime-local" name="starts_at" required style={inputStyle} />
        </div>

        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>End Date & Time *</label>
          <input type="datetime-local" name="ends_at" required style={inputStyle} />
        </div>

        {error && (
          <div style={{ background: 'rgba(239,68,68,0.1)', border: '1px solid rgba(239,68,68,0.3)', borderRadius: 8, padding: '10px 14px', color: '#EF4444', fontSize: 13, marginBottom: 16 }}>
            {error}
          </div>
        )}
        {success && (
          <div style={{ background: 'rgba(34,197,94,0.1)', border: '1px solid rgba(34,197,94,0.3)', borderRadius: 8, padding: '10px 14px', color: '#22C55E', fontSize: 13, marginBottom: 16 }}>
            Tournament created
          </div>
        )}

        <button
          type="submit"
          disabled={isPending}
          style={{ background: '#7C3AED', color: '#FFFFFF', border: 'none', borderRadius: 8, padding: '10px 24px', fontSize: 14, fontWeight: 600, cursor: isPending ? 'wait' : 'pointer', opacity: isPending ? 0.7 : 1 }}
        >
          {isPending ? 'Creating…' : 'Create Tournament'}
        </button>
      </form>
    </div>
  )
}
