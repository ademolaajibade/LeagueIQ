'use client'

import { useState, useTransition } from 'react'
import { createClub, updateClub } from '../actions'

interface League { id: string; name: string }
export interface ClubData { id: string; name: string; crest_url: string | null; league_id: string }

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

export default function ClubForm({ leagues, editClub, onCancel }: { leagues: League[]; editClub?: ClubData; onCancel?: () => void }) {
  const [isPending, startTransition] = useTransition()
  const [error,   setError]   = useState<string | null>(null)
  const [success, setSuccess] = useState(false)

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError(null)
    setSuccess(false)
    const formData = new FormData(e.currentTarget)
    startTransition(async () => {
      const result = editClub
        ? await updateClub(editClub.id, formData)
        : await createClub(formData)
      if (result?.error) setError(result.error)
      else {
        setSuccess(true)
        if (!editClub) (e.target as HTMLFormElement).reset()
        onCancel?.()
      }
    })
  }

  return (
    <div style={{ background: '#111827', border: '1px solid rgba(255,255,255,0.08)', borderRadius: 12, padding: 24 }}>
      <h2 style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 600, marginBottom: 20 }}>
        {editClub ? 'Edit Club' : 'Add Club'}
      </h2>
      <form onSubmit={handleSubmit}>
        <div style={{ marginBottom: 16 }}>
          <label style={labelStyle}>League *</label>
          <select name="league_id" required defaultValue={editClub?.league_id ?? ''} style={inputStyle} disabled={!!editClub}>
            <option value="">Select league…</option>
            {leagues.map(l => <option key={l.id} value={l.id}>{l.name}</option>)}
          </select>
        </div>
        <div style={{ marginBottom: 16 }}>
          <label style={labelStyle}>Club Name *</label>
          <input name="name" required defaultValue={editClub?.name ?? ''} style={inputStyle} placeholder="e.g. Arsenal" />
        </div>
        <div style={{ marginBottom: 24 }}>
          <label style={labelStyle}>Crest URL</label>
          <input name="crest_url" defaultValue={editClub?.crest_url ?? ''} style={inputStyle} placeholder="https://…" />
        </div>

        {error && (
          <div style={{ background: 'rgba(239,68,68,0.1)', border: '1px solid rgba(239,68,68,0.3)', borderRadius: 8, padding: '10px 14px', color: '#EF4444', fontSize: 13, marginBottom: 16 }}>
            {error}
          </div>
        )}
        {success && !editClub && (
          <div style={{ background: 'rgba(34,197,94,0.1)', border: '1px solid rgba(34,197,94,0.3)', borderRadius: 8, padding: '10px 14px', color: '#22C55E', fontSize: 13, marginBottom: 16 }}>
            Club added
          </div>
        )}

        <div style={{ display: 'flex', gap: 10 }}>
          <button type="submit" disabled={isPending} style={{ background: '#7C3AED', color: '#FFFFFF', border: 'none', borderRadius: 8, padding: '10px 20px', fontSize: 14, fontWeight: 600, cursor: isPending ? 'wait' : 'pointer', opacity: isPending ? 0.7 : 1 }}>
            {isPending ? 'Saving…' : editClub ? 'Save' : 'Add Club'}
          </button>
          {editClub && (
            <button type="button" onClick={onCancel} style={{ background: '#1A2235', color: '#94A3B8', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, padding: '10px 16px', fontSize: 14, cursor: 'pointer' }}>
              Cancel
            </button>
          )}
        </div>
      </form>
    </div>
  )
}
