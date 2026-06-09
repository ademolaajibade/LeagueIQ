import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const { data: profile, error: profileErr } = await db
      .from('profiles')
      .select('is_premium, xp_booster_expires_at')
      .eq('id', user.id)
      .single()

    if (profileErr || !profile) return serverError('Failed to fetch profile')
    if (!profile.is_premium) return badRequest('XP Booster is a premium feature')

    // Check if booster is already active
    if (
      profile.xp_booster_expires_at &&
      new Date(profile.xp_booster_expires_at) > new Date()
    ) {
      return badRequest('XP Booster is already active')
    }

    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString()

    await db
      .from('profiles')
      .update({ xp_booster_expires_at: expiresAt })
      .eq('id', user.id)

    return respond({ xp_booster_expires_at: expiresAt })
  } catch (e) {
    return serverError(e.message)
  }
})
