'use client'

import { useRouter, useSearchParams } from 'next/navigation'
import { useTransition, useState } from 'react'

interface League    { id: string; name: string }
interface Category  { id: string; name: string; league_id: string }

export default function QuestionFilters({ leagues, categories }: { leagues: League[]; categories: Category[] }) {
  const router      = useRouter()
  const searchParams = useSearchParams()
  const [, startTransition] = useTransition()

  const [league,   setLeague]   = useState(searchParams.get('league') ?? '')
  const [category, setCategory] = useState(searchParams.get('category') ?? '')
  const [difficulty, setDifficulty] = useState(searchParams.get('difficulty') ?? '')
  const [q,        setQ]        = useState(searchParams.get('q') ?? '')

  const filteredCategories = league ? categories.filter(c => c.league_id === league) : categories

  function apply(overrides: Record<string, string> = {}) {
    const params = new URLSearchParams()
    const vals = { league, category, difficulty, q, ...overrides }
    if (vals.league)     params.set('league',     vals.league)
    if (vals.category)   params.set('category',   vals.category)
    if (vals.difficulty) params.set('difficulty', vals.difficulty)
    if (vals.q)          params.set('q',           vals.q)
    startTransition(() => router.push(`/admin/questions?${params.toString()}`))
  }

  const inputStyle: React.CSSProperties = {
    background: '#1A2235',
    border: '1px solid rgba(255,255,255,0.1)',
    borderRadius: 8,
    color: '#FFFFFF',
    fontSize: 14,
    padding: '8px 12px',
  }

  return (
    <div style={{ display: 'flex', gap: 12, flexWrap: 'wrap', alignItems: 'flex-end' }}>
      <input
        placeholder="Search questions…"
        value={q}
        onChange={e => setQ(e.target.value)}
        onKeyDown={e => e.key === 'Enter' && apply({ q })}
        style={{ ...inputStyle, minWidth: 240 }}
      />

      <select value={league} onChange={e => { setLeague(e.target.value); setCategory(''); apply({ league: e.target.value, category: '' }) }} style={inputStyle}>
        <option value="">All Leagues</option>
        {leagues.map(l => <option key={l.id} value={l.id}>{l.name}</option>)}
      </select>

      <select value={category} onChange={e => { setCategory(e.target.value); apply({ category: e.target.value }) }} style={inputStyle}>
        <option value="">All Categories</option>
        {filteredCategories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
      </select>

      <select value={difficulty} onChange={e => { setDifficulty(e.target.value); apply({ difficulty: e.target.value }) }} style={inputStyle}>
        <option value="">All Difficulties</option>
        <option value="easy">Easy</option>
        <option value="medium">Medium</option>
        <option value="hard">Hard</option>
      </select>

      <button onClick={() => apply()} style={{ background: '#7C3AED', color: '#FFFFFF', border: 'none', borderRadius: 8, padding: '8px 16px', fontSize: 14, cursor: 'pointer' }}>
        Search
      </button>
    </div>
  )
}
