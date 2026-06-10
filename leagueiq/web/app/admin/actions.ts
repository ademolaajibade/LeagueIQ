'use server'

import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { createAdminClient } from '@/lib/supabase/admin'

async function verifyAdmin() {
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) throw new Error('Unauthorized')
  const { data: profile } = await supabase
    .from('profiles').select('role').eq('id', user.id).single()
  if (profile?.role !== 'admin') throw new Error('Forbidden')
}

// ─── Questions ────────────────────────────────────────────────────────────────

export async function createQuestion(formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const options = [
    formData.get('option0') as string,
    formData.get('option1') as string,
    formData.get('option2') as string,
    formData.get('option3') as string,
  ]

  const { error } = await admin.from('questions').insert({
    league_id:      formData.get('league_id') as string,
    category_id:    formData.get('category_id') as string,
    question:       formData.get('question') as string,
    options,
    correct_answer: Number(formData.get('correct_answer')),
    difficulty:     formData.get('difficulty') as string,
    fact:           (formData.get('fact') as string) || null,
    is_active:      formData.get('is_active') === 'true',
  })

  if (error) return { error: error.message }
  revalidatePath('/admin/questions')
  redirect('/admin/questions')
}

export async function updateQuestion(id: string, formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const options = [
    formData.get('option0') as string,
    formData.get('option1') as string,
    formData.get('option2') as string,
    formData.get('option3') as string,
  ]

  const { error } = await admin.from('questions').update({
    league_id:      formData.get('league_id') as string,
    category_id:    formData.get('category_id') as string,
    question:       formData.get('question') as string,
    options,
    correct_answer: Number(formData.get('correct_answer')),
    difficulty:     formData.get('difficulty') as string,
    fact:           (formData.get('fact') as string) || null,
    is_active:      formData.get('is_active') === 'true',
  }).eq('id', id)

  if (error) return { error: error.message }
  revalidatePath('/admin/questions')
  redirect('/admin/questions')
}

export async function deleteQuestion(id: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('questions').update({ is_active: false }).eq('id', id)
  revalidatePath('/admin/questions')
}

export async function toggleQuestionActive(id: string, isActive: boolean) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('questions').update({ is_active: isActive }).eq('id', id)
  revalidatePath('/admin/questions')
}

// ─── QOTD ─────────────────────────────────────────────────────────────────────

export async function scheduleQotd(formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const { error } = await admin.from('question_of_the_day').upsert({
    question_id: formData.get('question_id') as string,
    date:        formData.get('date') as string,
  }, { onConflict: 'date' })

  if (error) return { error: error.message }
  revalidatePath('/admin/qotd')
  return { success: true }
}

export async function deleteQotd(id: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('question_of_the_day').delete().eq('id', id)
  revalidatePath('/admin/qotd')
}

// ─── Tournaments ──────────────────────────────────────────────────────────────

export async function createTournament(formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const { error } = await admin.from('tournaments').insert({
    league_id:  formData.get('league_id') as string,
    starts_at:  formData.get('starts_at') as string,
    ends_at:    formData.get('ends_at') as string,
    status:     'upcoming',
  })

  if (error) return { error: error.message }
  revalidatePath('/admin/tournaments')
  return { success: true }
}

export async function updateTournamentStatus(id: string, status: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('tournaments').update({ status }).eq('id', id)
  revalidatePath('/admin/tournaments')
}

export async function deleteTournament(id: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('tournaments').delete().eq('id', id)
  revalidatePath('/admin/tournaments')
}

// ─── Clubs ────────────────────────────────────────────────────────────────────

export async function createClub(formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const { error } = await admin.from('clubs').insert({
    league_id: formData.get('league_id') as string,
    name:      formData.get('name') as string,
    crest_url: (formData.get('crest_url') as string) || null,
  })

  if (error) return { error: error.message }
  revalidatePath('/admin/clubs')
  return { success: true }
}

export async function updateClub(id: string, formData: FormData) {
  await verifyAdmin()
  const admin = createAdminClient()

  const { error } = await admin.from('clubs').update({
    name:      formData.get('name') as string,
    crest_url: (formData.get('crest_url') as string) || null,
  }).eq('id', id)

  if (error) return { error: error.message }
  revalidatePath('/admin/clubs')
  return { success: true }
}

export async function deleteClub(id: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('clubs').delete().eq('id', id)
  revalidatePath('/admin/clubs')
}

// ─── Users ────────────────────────────────────────────────────────────────────

export async function toggleUserRole(id: string, currentRole: string) {
  await verifyAdmin()
  const admin = createAdminClient()
  const newRole = currentRole === 'admin' ? 'user' : 'admin'
  await admin.from('profiles').update({ role: newRole }).eq('id', id)
  revalidatePath('/admin/users')
}

export async function toggleUserBan(id: string, isBanned: boolean) {
  await verifyAdmin()
  const admin = createAdminClient()
  await admin.from('profiles').update({ is_banned: !isBanned }).eq('id', id)
  revalidatePath('/admin/users')
}
