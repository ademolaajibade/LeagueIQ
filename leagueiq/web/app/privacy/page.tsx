import Link from 'next/link'

export const metadata = {
  title: 'Privacy Policy — LeagueIQ',
}

export default function PrivacyPage() {
  return (
    <div className="max-w-2xl mx-auto px-6 py-12 space-y-8 text-gray-300">
      <div>
        <Link href="/" className="text-iq-gold hover:opacity-80 text-sm">← Back</Link>
        <h1 className="text-3xl font-extrabold text-white mt-4 mb-1">Privacy Policy</h1>
        <p className="text-sm text-gray-500">Effective date: 1 July 2026</p>
      </div>

      <Section title="1. Who We Are">
        LeagueIQ ("we", "us", "our") is a football trivia platform covering the Big Five European leagues.
        Your privacy matters to us. This policy explains what data we collect, why we collect it, and how we protect it.
      </Section>

      <Section title="2. Data We Collect">
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li><strong className="text-white">Account information</strong> — email address, username, and profile photo (via Google OAuth where applicable).</li>
          <li><strong className="text-white">Game data</strong> — quiz results, XP, streaks, league mastery, leaderboard scores, and tournament entries.</li>
          <li><strong className="text-white">Device data</strong> — push notification token (Expo) used only to send you game alerts you have opted into.</li>
          <li><strong className="text-white">Payment data</strong> — premium subscription status and expiry. We use Paystack for payment processing; we never store your card details.</li>
          <li><strong className="text-white">Usage data</strong> — anonymous analytics to improve the product (e.g. which game modes are most popular).</li>
        </ul>
      </Section>

      <Section title="3. How We Use Your Data">
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li>To provide and personalise the LeagueIQ experience.</li>
          <li>To display your stats on leaderboards and in friend challenges.</li>
          <li>To send push notifications you have opted into (streaks, daily challenges, tournaments).</li>
          <li>To process premium subscriptions and verify payments.</li>
          <li>To communicate service updates or security alerts.</li>
        </ul>
        We do not sell your personal data to third parties.
      </Section>

      <Section title="4. Data Storage & Security">
        Your data is stored on Supabase (PostgreSQL), hosted in the EU region. We use row-level security
        (RLS) to ensure users can only access their own data. Passwords are hashed by Supabase Auth and
        never stored in plain text.
      </Section>

      <Section title="5. Third-Party Services">
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li><strong className="text-white">Supabase</strong> — database, authentication, and edge functions.</li>
          <li><strong className="text-white">Paystack</strong> — payment processing for premium subscriptions.</li>
          <li><strong className="text-white">Expo</strong> — push notification delivery.</li>
          <li><strong className="text-white">Google OAuth</strong> — optional sign-in via Google account.</li>
        </ul>
        Each third party operates under its own privacy policy and data-processing agreements.
      </Section>

      <Section title="6. Data Retention">
        We retain your account data for as long as your account is active. If you delete your account,
        all associated data (profile, game history, leaderboard entries) is permanently erased within 30 days.
      </Section>

      <Section title="7. Your Rights">
        You have the right to access, correct, or delete your personal data at any time.
        You can delete your account directly from the Profile screen. For other requests, contact us at
        {' '}<a href="mailto:privacy@leagueiq.app" className="text-iq-gold hover:underline">privacy@leagueiq.app</a>.
      </Section>

      <Section title="8. Children's Privacy">
        LeagueIQ is not directed at children under 13. We do not knowingly collect data from anyone under 13.
        If you believe a child has provided us with personal information, please contact us and we will delete it promptly.
      </Section>

      <Section title="9. Changes to This Policy">
        We may update this policy from time to time. We will notify you of significant changes via in-app notice
        or email. Continued use of LeagueIQ after changes constitutes acceptance.
      </Section>

      <Section title="10. Contact">
        Questions? Email us at{' '}
        <a href="mailto:privacy@leagueiq.app" className="text-iq-gold hover:underline">privacy@leagueiq.app</a>.
      </Section>
    </div>
  )
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="space-y-2">
      <h2 className="text-lg font-bold text-white">{title}</h2>
      <div className="text-sm leading-relaxed text-gray-400">{children}</div>
    </section>
  )
}
