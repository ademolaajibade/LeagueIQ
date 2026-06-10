'use client'

import { useState, useTransition } from 'react'
import { useRouter } from 'next/navigation'
import { createQuestion, updateQuestion } from '../actions'
import type { Question } from '@/types'

interface League   { id: string; name: string }
interface Category { id: string; name: string; league_id: string }

interface Props {
  leagues:    League[]
  categories: Category[]
  question?:  Question & { league_id: string; category_id: string }
}

const inputStyle: React.CSSProperties = {
  width: '100%',
  background: '#1A2235',
  border: '1px solid rgba(255,255,255,0.1)',
  borderRadius: 8,
  color: '#FFFFFF',
  fontSize: 14,
  padding: '10px 14px',
  boxSizing: 'border-box',
}

const labelStyle: React.CSSProperties = {
  display: 'block',
  color: '#94A3B8',
  fontSize: 13,
  marginBottom: 6,
  fontWeight: 500,
}

export default function QuestionForm({ leagues, categories, question }: Props) {
  const router = useRouter()
  const [isPending, startTransition] = useTransition()
  const [error, setError] = useState<string | null>(null)
  const [leagueId, setLeagueId] = useState(question?.league_id ?? '')

  const filteredCategories = leagueId
    ? categories.filter(c => c.league_id === leagueId)
    : categories

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault()
    setError(null)
    const formData = new FormData(e.currentTarget)
    startTransition(async () => {
      const result = question
        ? await updateQuestion(question.id, formData)
        : await createQuestion(formData)
      if (result?.error) setError(result.error)
      // redirect happens inside the action on success
    })
  }

  return (
    <form onSubmit={handleSubmit}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20, marginBottom: 20 }}>
        <div>
          <label style={labelStyle}>League *</label>
          <select
            name="league_id"
            required
            value={leagueId}
            onChange={e => setLeagueId(e.target.value)}
            style={inputStyle}
          >
            <option value="">Select league…</option>
            {leagues.map(l => <option key={l.id} value={l.id}>{l.name}</option>)}
          </select>
        </div>
        <div>
          <label style={labelStyle}>Category *</label>
          <select name="category_id" required defaultValue={question?.category_id ?? ''} style={inputStyle}>
            <option value="">Select category…</option>
            {filteredCategories.map(c => <option key={c.id} value={c.id}>{c.name}</option>)}
          </select>
        </div>
      </div>

      <div style={{ marginBottom: 20 }}>
        <label style={labelStyle}>Question *</label>
        <textarea
          name="question"
          required
          defaultValue={question?.question ?? ''}
          rows={3}
          style={{ ...inputStyle, resize: 'vertical' }}
          placeholder="Enter the question text…"
        />
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 16, marginBottom: 20 }}>
        {([0, 1, 2, 3] as const).map(i => (
          <div key={i}>
            <label style={labelStyle}>Option {i + 1} *</label>
            <input
              name={`option${i}`}
              required
              defaultValue={question?.options?.[i] ?? ''}
              style={inputStyle}
              placeholder={`Answer option ${i + 1}`}
            />
          </div>
        ))}
      </div>

      <div style={{ marginBottom: 20 }}>
        <label style={labelStyle}>Correct Answer *</label>
        <div style={{ display: 'flex', gap: 20 }}>
          {([0, 1, 2, 3] as const).map(i => (
            <label key={i} style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer', color: '#FFFFFF', fontSize: 14 }}>
              <input
                type="radio"
                name="correct_answer"
                value={i}
                defaultChecked={question?.correct_answer === i}
                required
              />
              Option {i + 1}
            </label>
          ))}
        </div>
      </div>

      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 20, marginBottom: 20 }}>
        <div>
          <label style={labelStyle}>Difficulty *</label>
          <select name="difficulty" required defaultValue={question?.difficulty ?? ''} style={inputStyle}>
            <option value="">Select…</option>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </select>
        </div>
        <div>
          <label style={labelStyle}>Active</label>
          <select name="is_active" defaultValue={question?.is_active === false ? 'false' : 'true'} style={inputStyle}>
            <option value="true">Yes</option>
            <option value="false">No</option>
          </select>
        </div>
      </div>

      <div style={{ marginBottom: 28 }}>
        <label style={labelStyle}>Did You Know fact</label>
        <textarea
          name="fact"
          defaultValue={question?.fact ?? ''}
          rows={2}
          style={{ ...inputStyle, resize: 'vertical' }}
          placeholder="Optional fun fact shown after the answer…"
        />
      </div>

      {error && (
        <div style={{ background: 'rgba(239,68,68,0.1)', border: '1px solid rgba(239,68,68,0.3)', borderRadius: 8, padding: '12px 16px', color: '#EF4444', fontSize: 14, marginBottom: 20 }}>
          {error}
        </div>
      )}

      <div style={{ display: 'flex', gap: 12 }}>
        <button
          type="submit"
          disabled={isPending}
          style={{ background: '#7C3AED', color: '#FFFFFF', border: 'none', borderRadius: 8, padding: '12px 28px', fontSize: 15, fontWeight: 600, cursor: isPending ? 'wait' : 'pointer', opacity: isPending ? 0.7 : 1 }}
        >
          {isPending ? 'Saving…' : question ? 'Save Changes' : 'Create Question'}
        </button>
        <button
          type="button"
          onClick={() => router.push('/admin/questions')}
          style={{ background: '#1A2235', color: '#94A3B8', border: '1px solid rgba(255,255,255,0.1)', borderRadius: 8, padding: '12px 20px', fontSize: 15, cursor: 'pointer' }}
        >
          Cancel
        </button>
      </div>
    </form>
  )
}
