import { corsHeaders } from '../_shared/cors.ts'
import { adminClient, getToken, respond, unauthorized, badRequest, serverError } from '../_shared/supabase.ts'

// Pricing in kobo (NGN × 100)
const PLAN_PRICES: Record<string, number> = {
  monthly: 200000,  // 2,000 NGN
  yearly: 1800000,  // 18,000 NGN
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
    const { plan } = body

    if (!plan || !PLAN_PRICES[plan]) return badRequest('plan must be "monthly" or "yearly"')

    // Fetch user email
    const { data: { user: authUser } } = await db.auth.admin.getUserById(user.id)
    const email = authUser?.email
    if (!email) return serverError('Could not determine user email')

    const paystackSecret = Deno.env.get('PAYSTACK_SECRET_KEY')
    if (!paystackSecret) return serverError('Payment provider not configured')

    const reference = `leagueiq_${user.id.replace(/-/g, '').slice(0, 12)}_${Date.now()}`

    const paystackRes = await fetch('https://api.paystack.co/transaction/initialize', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${paystackSecret}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email,
        amount: PLAN_PRICES[plan],
        reference,
        metadata: { user_id: user.id, plan },
        callback_url: `${Deno.env.get('APP_URL')}/payment/callback`,
      }),
    })

    if (!paystackRes.ok) {
      const err = await paystackRes.json()
      return serverError(`Payment initialization failed: ${err.message ?? 'Unknown error'}`)
    }

    const { data: paystackData } = await paystackRes.json()

    return respond({
      payment_url: paystackData.authorization_url,
      reference: paystackData.reference,
    })
  } catch (e) {
    return serverError(e.message)
  }
})
