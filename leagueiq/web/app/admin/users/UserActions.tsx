'use client'

import { useTransition } from 'react'
import { toggleUserRole, toggleUserBan } from '../actions'

export default function UserActions({ id, role, isBanned }: { id: string; role: string; isBanned: boolean }) {
  const [isPending, startTransition] = useTransition()

  function handleRoleToggle() {
    const action = role === 'admin' ? 'Demote to user' : 'Promote to admin'
    if (!confirm(`${action}?`)) return
    startTransition(() => toggleUserRole(id, role))
  }

  function handleBanToggle() {
    const action = isBanned ? 'Unban this user' : 'Ban this user'
    if (!confirm(`${action}?`)) return
    startTransition(() => toggleUserBan(id, isBanned))
  }

  return (
    <div style={{ display: 'flex', gap: 10 }}>
      <button
        onClick={handleRoleToggle}
        disabled={isPending}
        style={{ background: 'none', border: 'none', color: '#7C3AED', fontSize: 12, cursor: 'pointer', padding: 0, whiteSpace: 'nowrap' }}
      >
        {role === 'admin' ? 'Demote' : 'Make Admin'}
      </button>
      <button
        onClick={handleBanToggle}
        disabled={isPending}
        style={{ background: 'none', border: 'none', color: isBanned ? '#22C55E' : '#EF4444', fontSize: 12, cursor: 'pointer', padding: 0 }}
      >
        {isBanned ? 'Unban' : 'Ban'}
      </button>
    </div>
  )
}
