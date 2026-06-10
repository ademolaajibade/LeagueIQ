import { create } from 'zustand'
import type {
  GameSession,
  Question,
  SubmitAnswerResponse,
  EndSessionResponse,
  League,
  Category,
  GameMode,
} from '@/types'

interface PendingGame {
  league: League
  mode: GameMode | 'survival' | 'h2h'
  category: Category | null
}

interface GameState {
  pending: PendingGame | null

  session: GameSession | null
  questions: Omit<Question, 'correct_answer'>[]
  currentIndex: number
  answers: SubmitAnswerResponse[]
  startedAt: number | null

  endResult: EndSessionResponse | null

  survivalSessionId: string | null
  survivalQuestion: Omit<Question, 'correct_answer'> | null
  survivalCount: number
  survivalLeagueId: string | null

  setPending: (p: PendingGame) => void
  setSession: (session: GameSession, questions: Omit<Question, 'correct_answer'>[]) => void
  pushAnswer: (answer: SubmitAnswerResponse) => void
  nextQuestion: () => void
  setEndResult: (r: EndSessionResponse) => void
  startSurvival: (sessionId: string, question: Omit<Question, 'correct_answer'>, leagueId: string) => void
  setSurvivalQuestion: (q: Omit<Question, 'correct_answer'>) => void
  incrementSurvival: () => void
  reset: () => void
}

export const useGameStore = create<GameState>((set) => ({
  pending:           null,
  session:           null,
  questions:         [],
  currentIndex:      0,
  answers:           [],
  startedAt:         null,
  endResult:         null,
  survivalSessionId: null,
  survivalQuestion:  null,
  survivalCount:     0,
  survivalLeagueId:  null,

  setPending: (p) => set({ pending: p }),

  setSession: (session, questions) =>
    set({ session, questions, currentIndex: 0, answers: [], startedAt: Date.now(), endResult: null }),

  pushAnswer: (answer) =>
    set((s) => ({ answers: [...s.answers, answer] })),

  nextQuestion: () =>
    set((s) => ({ currentIndex: s.currentIndex + 1 })),

  setEndResult: (r) => set({ endResult: r }),

  startSurvival: (sessionId, question, leagueId) =>
    set({
      survivalSessionId: sessionId,
      survivalQuestion:  question,
      survivalCount:     0,
      survivalLeagueId:  leagueId,
    }),

  setSurvivalQuestion: (q) => set({ survivalQuestion: q }),

  incrementSurvival: () =>
    set((s) => ({ survivalCount: s.survivalCount + 1 })),

  reset: () =>
    set({
      pending:           null,
      session:           null,
      questions:         [],
      currentIndex:      0,
      answers:           [],
      startedAt:         null,
      endResult:         null,
      survivalSessionId: null,
      survivalQuestion:  null,
      survivalCount:     0,
      survivalLeagueId:  null,
    }),
}))
