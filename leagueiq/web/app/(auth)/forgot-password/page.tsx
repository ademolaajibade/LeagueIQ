'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

export default function ForgotPasswordPage() {
  const supabase          = createClient()
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)
  const [sent, setSent]       = useState(false)

  const handleReset = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)
    const { error } = await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${window.location.origin}/auth/callback`,
    })
    if (error) { setError(error.message); setLoading(false); return }
    setSent(true)
    setLoading(false)
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <h1 className="text-3xl font-extrabold text-center tracking-tight mb-2">Reset Password</h1>
        <p className="text-gray-400 text-center text-sm mb-10">
          Enter your email to receive a password reset link.
        </p>

        {sent ? (
          <div
            className="rounded-2xl p-5 border text-center space-y-2"
            style={{ background: 'rgba(245,197,24,0.06)', borderColor: 'rgba(245,197,24,0.25)' }}
          >
            <p className="font-bold text-iq-gold text-lg">Check your email</p>
            <p className="text-sm text-gray-400">
              We sent a reset link to <strong className="text-white">{email}</strong>.
              Follow it to set a new password.
            </p>
          </div>
        ) : (
          <form onSubmit={handleReset} className="space-y-3">
            <input
              type="email"
              placeholder="Email"
              value={email}
              onChange={e => setEmail(e.target.value)}
              required
              className="w-full px-4 py-3 rounded-xl bg-gray-900 text-white placeholder-gray-600 border border-gray-800 focus:outline-none focus:border-iq-gold transition"
            />
            {error && <p className="text-red-400 text-sm">{error}</p>}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 rounded-xl bg-iq-gold hover:opacity-90 text-black font-bold disabled:opacity-40 transition"
            >
              {loading ? 'Sending…' : 'Send Reset Link'}
            </button>
          </form>
        )}

        <p className="text-center text-gray-600 text-sm mt-8">
          <Link href="/login" className="text-iq-gold hover:opacity-80 font-semibold">
            Back to Sign In
          </Link>
        </p>
      </div>
    </div>
  )
}
