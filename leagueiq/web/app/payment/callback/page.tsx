'use client'

import { useEffect, useState } from 'react'
import { useRouter, useSearchParams } from 'next/navigation'
import { COLORS } from '@/lib/colors'
import { verifyPayment } from '@/lib/api'

type Status = 'verifying' | 'success' | 'failed'

export default function PaymentCallbackPage() {
  const router       = useRouter()
  const searchParams = useSearchParams()
  const reference    = searchParams.get('reference') ?? searchParams.get('trxref')

  const [status, setStatus] = useState<Status>('verifying')

  useEffect(() => {
    if (!reference) {
      setStatus('failed')
      return
    }

    verifyPayment({ reference })
      .then(() => {
        setStatus('success')
        setTimeout(() => router.replace('/profile'), 2500)
      })
      .catch(() => {
        setStatus('failed')
      })
  }, [reference])

  const copy: Record<Status, { icon: string; title: string; body: string }> = {
    verifying: {
      icon:  '⏳',
      title: 'Verifying payment…',
      body:  'Please wait while we confirm your payment.',
    },
    success: {
      icon:  '✅',
      title: 'Payment successful!',
      body:  'Welcome to LeagueIQ Premium. Redirecting you…',
    },
    failed: {
      icon:  '❌',
      title: 'Payment not confirmed',
      body:  reference
        ? 'We could not confirm this payment. If you were charged, contact support.'
        : 'No payment reference found. Please try again.',
    },
  }

  const { icon, title, body } = copy[status]

  return (
    <div
      className="min-h-screen flex items-center justify-center px-4"
      style={{ background: COLORS.background }}
    >
      <div
        className="max-w-sm w-full rounded-2xl p-8 border text-center space-y-4"
        style={{ background: COLORS.surface, borderColor: COLORS.border }}
      >
        <p className="text-5xl">{icon}</p>
        <p className="text-xl font-black text-white">{title}</p>
        <p className="text-sm leading-relaxed" style={{ color: COLORS.textSecondary }}>{body}</p>

        {status === 'verifying' && (
          <div className="flex justify-center mt-2">
            <div
              className="w-6 h-6 border-2 border-t-transparent rounded-full animate-spin"
              style={{ borderColor: COLORS.gold }}
            />
          </div>
        )}

        {status === 'failed' && (
          <button
            onClick={() => router.replace('/profile')}
            className="mt-4 w-full rounded-xl py-3 font-bold border"
            style={{ color: COLORS.gold, borderColor: COLORS.gold }}
          >
            Back to Profile
          </button>
        )}
      </div>
    </div>
  )
}
