import { createClient, SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from './cors.ts'

export function adminClient(): SupabaseClient {
  return createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    { auth: { autoRefreshToken: false, persistSession: false } },
  )
}

export function userClient(token: string): SupabaseClient {
  return createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    {
      auth: { autoRefreshToken: false, persistSession: false },
      global: { headers: { Authorization: `Bearer ${token}` } },
    },
  )
}

export function getToken(req: Request): string | null {
  const auth = req.headers.get('Authorization')
  return auth?.startsWith('Bearer ') ? auth.slice(7) : null
}

export function respond(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

export function unauthorized(): Response {
  return respond({ error: 'Unauthorized' }, 401)
}

export function badRequest(msg: string): Response {
  return respond({ error: msg }, 400)
}

export function serverError(msg: string): Response {
  return respond({ error: msg }, 500)
}

// ── Shared game logic ────────────────────────────────────────

export function calcXp(
  difficulty: string,
  timeTakenMs: number,
  boosterActive: boolean,
): number {
  const base = difficulty === 'hard' ? 20 : difficulty === 'medium' ? 15 : 10
  const speedBonus = timeTakenMs < 3000 ? 5 : timeTakenMs < 5000 ? 2 : 0
  const total = base + speedBonus
  return boosterActive ? total * 2 : total
}

export function calcLevel(xp: number): string {
  if (xp >= 10000) return 'Legend'
  if (xp >= 5000) return 'Platinum'
  if (xp >= 2000) return 'Gold'
  if (xp >= 500) return 'Silver'
  return 'Bronze'
}

export function calcMasteryLevel(categoriesCompleted: number): string {
  if (categoriesCompleted >= 7) return 'Ultras'
  if (categoriesCompleted >= 5) return 'Expert'
  if (categoriesCompleted >= 2) return 'Fan'
  return 'Rookie'
}
