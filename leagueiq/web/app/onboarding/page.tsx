'use client'

import { useEffect, useRef, useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { Club, League } from '../../../types/index'

type Step = 'username' | 'league' | 'club'
const STEPS: Step[] = ['username', 'league', 'club']

export default function OnboardingPage() {
  const router  = useRouter()
  const supabase = createClient()

  const [step, setStep]                     = useState<Step>('username')
  const [username, setUsername]             = useState('')
  const [usernameError, setUsernameError]   = useState('')
  const [checkingUsername, setChecking]     = useState(false)
  const [leagues, setLeagues]               = useState<League[]>([])
  const [selectedLeague, setSelectedLeague] = useState<League | null>(null)
  const [clubs, setClubs]                   = useState<Club[]>([])
  const [selectedClub, setSelectedClub]     = useState<Club | null>(null)
  const [saving, setSaving]                 = useState(false)
  const [error, setError]                   = useState<string | null>(null)

  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    supabase.auth.getUser().then(({ data: { user } }) => {
      if (!user) { router.push('/login'); return }
      const prefix = user.email?.split('@')[0] ?? ''
      setUsername(prefix.replace(/[^a-zA-Z0-9_]/g, ''))
    })
    supabase.from('leagues').select('*').order('name').then(({ data }) => {
      if (data) setLeagues(data as League[])
    })
  }, [])

  useEffect(() => {
    if (!selectedLeague) return
    setClubs([])
    supabase
      .from('clubs')
      .select('*')
      .eq('league_id', selectedLeague.id)
      .order('name')
      .then(({ data }) => { if (data) setClubs(data as Club[]) })
  }, [selectedLeague])

  const validateUsername = (val: string) => {
    if (val.length < 3)  return 'Must be at least 3 characters'
    if (val.length > 20) return 'Must be 20 characters or fewer'
    if (!/^[a-zA-Z0-9_]+$/.test(val)) return 'Letters, numbers, and underscores only'
    return ''
  }

  const onUsernameChange = (val: string) => {
    setUsername(val)
    const err = validateUsername(val)
    setUsernameError(err)
    if (err) return

    if (debounceRef.current) clearTimeout(debounceRef.current)
    setChecking(true)
    debounceRef.current = setTimeout(async () => {
      const { data: { user } } = await supabase.auth.getUser()
      const { data } = await supabase
        .from('profiles')
        .select('id')
        .eq('username', val)
        .neq('id', user?.id ?? '')
        .maybeSingle()
      setChecking(false)
      if (data) setUsernameError('Username is already taken')
    }, 500)
  }

  const goToLeague = (e: React.FormEvent) => {
    e.preventDefault()
    const err = validateUsername(username)
    if (err) { setUsernameError(err); return }
    if (checkingUsername || usernameError) return
    setStep('league')
  }

  const selectLeague = (league: League) => {
    setSelectedLeague(league)
    setSelectedClub(null)
    setStep('club')
  }

  const finish = async (skipClub = false) => {
    setSaving(true)
    setError(null)
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) { router.push('/login'); return }

    const { error } = await supabase
      .from('profiles')
      .update({
        username,
        preferred_league_id:  selectedLeague?.id ?? null,
        club_id:              skipClub ? null : (selectedClub?.id ?? null),
        onboarding_completed: true,
      })
      .eq('id', user.id)

    setSaving(false)
    if (error) { setError(error.message); return }
    router.push('/home')
    router.refresh()
  }

  const stepIndex = STEPS.indexOf(step)

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        {/* Progress bar */}
        <div className="flex gap-2 mb-10">
          {STEPS.map((s, i) => (
            <div
              key={s}
              className={`flex-1 h-1 rounded-full transition-colors duration-300 ${
                i < stepIndex ? 'bg-emerald-400' :
                i === stepIndex ? 'bg-emerald-400' : 'bg-gray-800'
              }`}
            />
          ))}
        </div>

        {/* Step 1: Username */}
        {step === 'username' && (
          <form onSubmit={goToLeague}>
            <p className="text-xs font-semibold tracking-widest text-gray-600 uppercase mb-3">Step 1 of 3</p>
            <h2 className="text-3xl font-extrabold tracking-tight mb-2">Pick your username</h2>
            <p className="text-gray-400 text-sm mb-8">This is how other players will know you.</p>

            <input
              type="text"
              value={username}
              onChange={e => onUsernameChange(e.target.value)}
              placeholder="username"
              autoCapitalize="none"
              autoCorrect="off"
              className={`w-full px-4 py-3 rounded-xl bg-gray-900 text-white text-lg placeholder-gray-600 border focus:outline-none transition mb-2 ${
                usernameError ? 'border-red-500' : 'border-gray-800 focus:border-emerald-500'
              }`}
            />

            {checkingUsername && (
              <p className="text-gray-500 text-sm mb-4">Checking availability…</p>
            )}
            {usernameError && !checkingUsername && (
              <p className="text-red-400 text-sm mb-4">{usernameError}</p>
            )}
            {!usernameError && !checkingUsername && username.length >= 3 && (
              <p className="text-emerald-400 text-sm mb-4">✓ @{username} is available</p>
            )}

            <button
              type="submit"
              disabled={!!usernameError || checkingUsername || username.length < 3}
              className="w-full py-3 rounded-xl bg-emerald-400 hover:bg-emerald-300 text-black font-bold disabled:opacity-30 transition"
            >
              Continue
            </button>
          </form>
        )}

        {/* Step 2: League */}
        {step === 'league' && (
          <div>
            <p className="text-xs font-semibold tracking-widest text-gray-600 uppercase mb-3">Step 2 of 3</p>
            <h2 className="text-3xl font-extrabold tracking-tight mb-2">Choose your league</h2>
            <p className="text-gray-400 text-sm mb-8">Which competition do you follow the most?</p>

            <div className="space-y-3">
              {leagues.length === 0
                ? <div className="text-gray-600 text-sm text-center py-8">Loading…</div>
                : leagues.map(league => (
                    <button
                      key={league.id}
                      onClick={() => selectLeague(league)}
                      className="w-full flex items-center justify-between p-5 rounded-xl bg-gray-900 border border-gray-800 hover:border-gray-600 text-left transition group"
                    >
                      <span
                        className="font-bold text-lg"
                        style={{ color: league.accent_color }}
                      >
                        {league.name}
                      </span>
                      <span className="text-gray-600 group-hover:text-gray-400 transition">→</span>
                    </button>
                  ))
              }
            </div>
          </div>
        )}

        {/* Step 3: Club */}
        {step === 'club' && (
          <div>
            <p className="text-xs font-semibold tracking-widest text-gray-600 uppercase mb-3">Step 3 of 3</p>
            <h2 className="text-3xl font-extrabold tracking-tight mb-2">Pick your club</h2>
            <p className="text-gray-400 text-sm mb-8">
              Your team in{' '}
              <span style={{ color: selectedLeague?.accent_color }}>
                {selectedLeague?.name}
              </span>
              ?
            </p>

            {clubs.length === 0
              ? <div className="text-gray-600 text-sm text-center py-8">Loading…</div>
              : (
                <div className="grid grid-cols-2 gap-2.5 mb-6 max-h-72 overflow-y-auto pr-1">
                  {clubs.map(club => (
                    <button
                      key={club.id}
                      onClick={() => setSelectedClub(c => c?.id === club.id ? null : club)}
                      className={`p-4 rounded-xl border text-sm font-semibold text-center transition ${
                        selectedClub?.id === club.id
                          ? 'text-white bg-gray-800'
                          : 'border-gray-800 bg-gray-900 text-gray-300 hover:border-gray-600'
                      }`}
                      style={selectedClub?.id === club.id ? { borderColor: selectedLeague?.accent_color } : undefined}
                    >
                      {club.name}
                    </button>
                  ))}
                </div>
              )
            }

            {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

            <div className="flex gap-3">
              <button
                onClick={() => finish(true)}
                disabled={saving}
                className="py-3 px-5 rounded-xl border border-gray-800 text-gray-500 hover:border-gray-600 hover:text-gray-300 font-semibold disabled:opacity-40 transition text-sm"
              >
                Skip
              </button>
              <button
                onClick={() => finish(false)}
                disabled={!selectedClub || saving}
                className="flex-1 py-3 rounded-xl bg-emerald-400 hover:bg-emerald-300 text-black font-bold disabled:opacity-30 transition"
              >
                {saving ? 'Saving…' : "Let's go!"}
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
