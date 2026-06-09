import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

const PLAN_DURATIONS_MS: Record<string, number> = {
  monthly: 30 * 24 * 60 * 60 * 1000,
  yearly: 365 * 24 * 60 * 60 * 1000,
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })

  const token = getToken(req)
  if (!token) return unauthorized()

  const db = adminClient()
  const { data: { user }, error: authErr } = await db.auth.getUser(token)
  if (authErr || !user) return unauthorized()

  try {
    const body = await req.json()
    const { reference } = body
    if (!reference) return badRequest('reference is required')

    const paystackSecret = Deno.env.get('PAYSTACK_SECRET_KEY')
    if (!paystackSecret) return serverError('Payment provider not configured')

    // Verify with Paystack
    const verifyRes = await fetch(
      `https://api.paystack.co/transaction/verify/${encodeURIComponent(reference)}`,
      {
        headers: { Authorization: `Bearer ${paystackSecret}` },
      },
    )

    if (!verifyRes.ok) return serverError('Payment verification request failed')

    const { data: txn } = await verifyRes.json()

    if (txn.status !== 'success') {
      return respond({ verified: false, status: txn.status }, 402)
    }

    const plan: string = txn.metadata?.plan ?? 'monthly'
    const duration = PLAN_DURATIONS_MS[plan] ?? PLAN_DURATIONS_MS.monthly
    const expiresAt = new Date(Date.now() + duration).toISOString()

    // Upsert subscription
    const { data: subscription, error: subErr } = await db
      .from('subscriptions')
      .upsert(
        {
          user_id: user.id,
          provider: 'paystack',
          plan,
          status: 'active',
          provider_reference: reference,
          started_at: new Date().toISOString(),
          expires_at: expiresAt,
        },
        { onConflict: 'user_id' },
      )
      .select()
      .single()

    if (subErr) return serverError('Failed to record subscription')

    // Mark user as premium
    await db
      .from('profiles')
      .update({ is_premium: true })
      .eq('id', user.id)

    return respond({ verified: true, subscription })
  } catch (e) {
    return serverError(e.message)
  }
})
