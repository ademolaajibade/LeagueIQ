import { corsHeaders } from '../_shared/cors.ts'
import { adminClient } from '../_shared/supabase.ts'

// Paystack sends HMAC-SHA512 signature in x-paystack-signature header
async function verifySignature(secret: string, payload: string, signature: string): Promise<boolean> {
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-512' },
    false,
    ['sign'],
  )
  const sig = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(payload))
  const hex = Array.from(new Uint8Array(sig)).map((b) => b.toString(16).padStart(2, '0')).join('')
  return hex === signature
}

const PLAN_DURATIONS_MS: Record<string, number> = {
  monthly: 30 * 24 * 60 * 60 * 1000,
  yearly:  365 * 24 * 60 * 60 * 1000,
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })
  if (req.method !== 'POST') return new Response('Method not allowed', { status: 405 })

  const paystackSecret = Deno.env.get('PAYSTACK_SECRET_KEY')
  if (!paystackSecret) return new Response('Payment provider not configured', { status: 500 })

  const rawBody = await req.text()
  const signature = req.headers.get('x-paystack-signature') ?? ''

  const valid = await verifySignature(paystackSecret, rawBody, signature)
  if (!valid) return new Response('Invalid signature', { status: 401 })

  const db = adminClient()
  let event: { event: string; data: Record<string, unknown> }

  try {
    event = JSON.parse(rawBody)
  } catch {
    return new Response('Invalid JSON', { status: 400 })
  }

  // Log the webhook event for debugging
  await db.from('webhook_events').insert({
    provider: 'paystack',
    event_type: event.event,
    payload: event.data,
  }).then(() => {})

  const data = event.data

  try {
    switch (event.event) {
      case 'charge.success': {
        const reference = data.reference as string
        const metadata  = data.metadata as Record<string, string> | null
        const userId    = metadata?.user_id
        const plan      = (metadata?.plan ?? 'monthly') as string

        if (!userId || !reference) break

        const duration  = PLAN_DURATIONS_MS[plan] ?? PLAN_DURATIONS_MS.monthly
        const expiresAt = new Date(Date.now() + duration).toISOString()

        await db.from('subscriptions').upsert(
          {
            user_id:            userId,
            provider:           'paystack',
            plan,
            status:             'active',
            provider_reference: reference,
            started_at:         new Date().toISOString(),
            expires_at:         expiresAt,
          },
          { onConflict: 'user_id' },
        )
        await db.from('profiles').update({ is_premium: true }).eq('id', userId)
        break
      }

      case 'subscription.disable':
      case 'subscription.not_renew': {
        const customer  = data.customer as Record<string, string> | null
        const userEmail = customer?.email
        if (!userEmail) break

        const { data: profile } = await db
          .from('profiles')
          .select('id')
          .eq('email', userEmail)
          .single()

        if (!profile) break

        await db.from('subscriptions').update({ status: 'cancelled' }).eq('user_id', profile.id)
        await db.from('profiles').update({ is_premium: false }).eq('id', profile.id)
        break
      }

      case 'invoice.payment_failed': {
        const subscription = data.subscription as Record<string, unknown> | null
        const reference    = (subscription?.provider_reference ?? data.reference) as string | null
        if (!reference) break

        await db.from('subscriptions').update({ status: 'expired' }).eq('provider_reference', reference)
        // Fetch user_id to flip is_premium
        const { data: sub } = await db
          .from('subscriptions')
          .select('user_id')
          .eq('provider_reference', reference)
          .single()

        if (sub) {
          await db.from('profiles').update({ is_premium: false }).eq('id', sub.user_id)
        }
        break
      }

      default:
        // Unknown event — ack and move on
        break
    }
  } catch (_e) {
    // Ack the webhook even on internal errors to prevent Paystack retries
  }

  return new Response(JSON.stringify({ received: true }), {
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
})
