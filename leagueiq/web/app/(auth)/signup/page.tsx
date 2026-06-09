'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'

export default function SignupPage() {
  const router = useRouter()
  const supabase = createClient()
  const [email, setEmail]       = useState('')
  const [password, setPassword] = useState('')
  const [confirm, setConfirm]   = useState('')
  const [error, setError]       = useState<string | null>(null)
  const [loading, setLoading]   = useState(false)
  const [sent, setSent]         = useState(false)

  const signUp = async (e: React.FormEvent) => {
    e.preventDefault()
    if (password !== confirm) { setError('Passwords do not match'); return }
    if (password.length < 8)  { setError('Password must be at least 8 characters'); return }
    setLoading(true)
    setError(null)
    const { error } = await supabase.auth.signUp({ email, password })
    if (error) { setError(error.message); setLoading(false); return }
    setSent(true)
  }

  const signUpWithGoogle = async () => {
    setLoading(true)
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: `${window.location.origin}/auth/callback` },
    })
    if (error) { setError(error.message); setLoading(false) }
  }

  if (sent) {
    return (
      <div className="min-h-screen flex items-center justify-center px-4">
        <div className="w-full max-w-sm text-center">
          <div className="text-4xl mb-4">📬</div>
          <h2 className="text-2xl font-bold mb-3">Check your inbox</h2>
          <p className="text-gray-400 mb-2">
            We sent a confirmation link to{' '}
            <span className="text-emerald-400 font-semibold">{email}</span>.
          </p>
          <p className="text-gray-600 text-sm mb-8">
            Click the link to verify your account, then sign in.
          </p>
          <Link
            href="/login"
            className="inline-block w-full py-3 rounded-xl bg-gray-900 border border-gray-800 text-white font-semibold hover:border-gray-600 transition"
          >
            Back to Sign In
          </Link>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <h1 className="text-3xl font-extrabold tracking-tight mb-1">Create account</h1>
        <p className="text-gray-400 text-sm mb-8">Join the LeagueIQ community</p>

        <form onSubmit={signUp} className="space-y-3">
          <input
            type="email"
            placeholder="Email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            required
            className="w-full px-4 py-3 rounded-xl bg-gray-900 text-white placeholder-gray-600 border border-gray-800 focus:outline-none focus:border-emerald-500 transition"
          />
          <input
            type="password"
            placeholder="Password (min 8 characters)"
            value={password}
            onChange={e => setPassword(e.target.value)}
            required
            minLength={8}
            className="w-full px-4 py-3 rounded-xl bg-gray-900 text-white placeholder-gray-600 border border-gray-800 focus:outline-none focus:border-emerald-500 transition"
          />
          <input
            type="password"
            placeholder="Confirm password"
            value={confirm}
            onChange={e => setConfirm(e.target.value)}
            required
            className="w-full px-4 py-3 rounded-xl bg-gray-900 text-white placeholder-gray-600 border border-gray-800 focus:outline-none focus:border-emerald-500 transition"
          />
          {error && <p className="text-red-400 text-sm">{error}</p>}
          <button
            type="submit"
            disabled={loading}
            className="w-full py-3 rounded-xl bg-emerald-400 hover:bg-emerald-300 text-black font-bold disabled:opacity-40 transition"
          >
            {loading ? 'Creating account…' : 'Create Account'}
          </button>
        </form>

        <div className="flex items-center gap-3 my-6">
          <div className="flex-1 h-px bg-gray-800" />
          <span className="text-gray-600 text-xs">or</span>
          <div className="flex-1 h-px bg-gray-800" />
        </div>

        <button
          onClick={signUpWithGoogle}
          disabled={loading}
          className="w-full py-3 rounded-xl bg-gray-900 border border-gray-800 hover:border-gray-600 text-white font-semibold disabled:opacity-40 transition flex items-center justify-center gap-3"
        >
          <GoogleIcon />
          Continue with Google
        </button>

        <p className="text-center text-gray-600 text-sm mt-8">
          Already have an account?{' '}
          <Link href="/login" className="text-emerald-400 hover:text-emerald-300 font-semibold">
            Sign in
          </Link>
        </p>
      </div>
    </div>
  )
}

function GoogleIcon() {
  return (
    <svg className="w-5 h-5" viewBox="0 0 24 24">
      <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
      <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
      <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
      <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
    </svg>
  )
}
