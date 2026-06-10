'use client'

import { useTransition } from 'react'
import { updateTournamentStatus, deleteTournament } from '../actions'

export default function TournamentActions({ id, status }: { id: string; status: string }) {
  const [isPending, startTransition] = useTransition()

  function cycleStatus() {
    const next = status === 'upcoming' ? 'active' : status === 'active' ? 'completed' : 'upcoming'
    startTransition(() => updateTournamentStatus(id, next))
  }

  function handleDelete() {
    if (!confirm('Delete this tournament?')) return
    startTransition(() => deleteTournament(id))
  }

  const nextLabel = status === 'upcoming' ? 'Activate' : status === 'active' ? 'Complete' : 'Reopen'

  return (
    <div style={{ display: 'flex', gap: 12 }}>
      <button
        onClick={cycleStatus}
        disabled={isPending}
        style={{ background: 'none', border: 'none', color: '#7C3AED', fontSize: 13, cursor: 'pointer', padding: 0 }}
      >
        {nextLabel}
      </button>
      <button
        onClick={handleDelete}
        disabled={isPending}
        style={{ background: 'none', border: 'none', color: '#EF4444', fontSize: 13, cursor: 'pointer', padding: 0 }}
      >
        Delete
      </button>
    </div>
  )
}
