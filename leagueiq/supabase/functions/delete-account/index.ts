import { corsHeaders } from '../_shared/cors.ts'
import {
  adminClient, getToken, respond, unauthorized, serverError,
} from '../_shared/supabase.ts'

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    // Deleting the auth user cascades to the profile row via ON DELETE CASCADE
    const { error } = await db.auth.admin.deleteUser(user.id)
    if (error) return serverError(error.message)
    return respond({ success: true })
  } catch (e) {
    return serverError(e.message)
  }
})
