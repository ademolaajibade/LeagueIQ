'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { Profile } from '../../../types/index'

export default function HomePage() {
  const router   = useRouter()
  const supabase = createClient()
  const [profile, setProfile] = useState<Profile | null>(null)

  useEffect(() => {
    async function load() {
      const { data: { user } } = await supabase.auth.getUser()
      if (!user) { router.push('/login'); return }
      const { data } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single()
      if (data) setProfile(data as Profile)
    }
    load()
  }, [])

  const signOut = async () => {
    await supabase.auth.signOut()
    router.push('/login')
  }

  return (
    <div className="min-h-screen p-8">
      <div className="max-w-2xl mx-auto">
        <div className="flex items-center justify-between mb-10">
          <span className="text-xl font-extrabold tracking-tight">LeagueIQ</span>
          <button
            onClick={signOut}
            className="text-gray-500 hover:text-gray-300 text-sm transition"
          >
            Sign out
          </button>
        </div>

        {profile && (
          <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 mb-6">
            <p className="text-gray-400 text-sm mb-1">Welcome back,</p>
            <p className="text-2xl font-extrabold tracking-tight">@{profile.username}</p>
            <div className="flex gap-8 mt-5">
              <Stat label="Level"  value={profile.level} />
              <Stat label="XP"     value={profile.xp.toLocaleString()} />
              <Stat label="Streak" value={`${profile.streak}d`} />
            </div>
          </div>
        )}

        <div className="bg-gray-900 border border-gray-800 rounded-2xl p-6 text-center">
          <p className="text-gray-600 text-sm">
            Phase 3 complete — auth and onboarding are live.
          </p>
          <p className="text-gray-700 text-sm mt-1">
            Game modes arrive in Phase 5 (Mobile) and Phase 6 (Web).
          </p>
        </div>
      </div>
    </div>
  )
}

function Stat({ label, value }: { label: string; value: string | number }) {
  return (
    <div>
      <p className="text-gray-500 text-xs uppercase tracking-wider mb-1">{label}</p>
      <p className="text-white font-bold">{value}</p>
    </div>
  )
}
