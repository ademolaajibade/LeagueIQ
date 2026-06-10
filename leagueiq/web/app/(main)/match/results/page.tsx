'use client'

import { useEffect, useState } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { COLORS } from '@/lib/colors'

export default function MatchResultsPage() {
  const params   = useSearchParams()
  const router   = useRouter()
  const supabase = createClient()

  const matchId  = params.get('match_id')
  const winnerId = params.get('winner_id')

  const [myUserId, setMyUserId] = useState<string | null>(null)

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => setMyUserId(data.user?.id ?? null))
  }, [])

  const isWinner = winnerId && myUserId && winnerId === myUserId
  const isTie    = !winnerId

  return (
    <div className="flex flex-col items-center justify-center min-h-[60vh] gap-6 px-8">
      <span className="text-7xl">{isTie ? '🤝' : isWinner ? '🏆' : '😔'}</span>
      <h1 className="text-4xl font-black text-white">
        {isTie ? "It's a Tie!" : isWinner ? 'You Win!' : 'You Lose'}
      </h1>
      <p className="text-base text-center" style={{ color: COLORS.textMuted }}>
        {isTie
          ? 'Great match — both players are evenly matched.'
          : isWinner
          ? 'You earned 50 XP for winning!'
          : 'You earned 20 XP for participating.'}
      </p>
      <div className="w-full max-w-xs space-y-3 mt-4">
        <button
          onClick={() => router.push('/play')}
          className="w-full rounded-2xl py-4 font-bold text-black"
          style={{ background: COLORS.gold }}
        >
          Play Again
        </button>
        <button
          onClick={() => router.push('/home')}
          className="w-full rounded-2xl py-3.5 font-semibold border"
          style={{ color: COLORS.textSecondary, borderColor: COLORS.border }}
        >
          Home
        </button>
      </div>
    </div>
  )
}
