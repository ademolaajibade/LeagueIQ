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
    const body = await req.json()
    const push_token: string | undefined = body.token ?? body.push_token
    if (!push_token) return badRequest('token is required')

    const { error } = await db
      .from('profiles')
      .update({ push_token })
      .eq('id', user.id)

    if (error) return serverError('Failed to register push token')

    return respond({ ok: true })
  } catch (e) {
    return serverError(e.message)
  }
})
