import Link from 'next/link'

export const metadata = {
  title: 'Terms of Service — LeagueIQ',
}

export default function TermsPage() {
  return (
    <div className="max-w-2xl mx-auto px-6 py-12 space-y-8 text-gray-300">
      <div>
        <Link href="/" className="text-iq-gold hover:opacity-80 text-sm">← Back</Link>
        <h1 className="text-3xl font-extrabold text-white mt-4 mb-1">Terms of Service</h1>
        <p className="text-sm text-gray-500">Effective date: 1 July 2026</p>
      </div>

      <Section title="1. Acceptance of Terms">
        By creating a LeagueIQ account or using our app or website, you agree to these Terms of Service.
        If you do not agree, please do not use LeagueIQ.
      </Section>

      <Section title="2. Eligibility">
        You must be at least 13 years old to use LeagueIQ. By using the service you confirm that you meet
        this requirement. Users in jurisdictions where the minimum age is higher must meet the local requirement.
      </Section>

      <Section title="3. Your Account">
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li>You are responsible for maintaining the security of your account credentials.</li>
          <li>Your username must not impersonate another person or contain offensive language.</li>
          <li>You may only create one account. Duplicate accounts may be removed.</li>
          <li>You must not share, sell, or transfer your account to another person.</li>
        </ul>
      </Section>

      <Section title="4. Acceptable Use">
        You agree not to:
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li>Use cheats, bots, or automated tools to manipulate scores or leaderboards.</li>
          <li>Attempt to reverse-engineer, hack, or disrupt the LeagueIQ service or its infrastructure.</li>
          <li>Harass, abuse, or threaten other players.</li>
          <li>Use the service for any unlawful purpose.</li>
        </ul>
        Violations may result in suspension or permanent removal of your account.
      </Section>

      <Section title="5. Premium Subscriptions">
        <ul className="list-disc list-inside space-y-1 mt-2">
          <li>Premium plans (monthly or yearly) are processed via Paystack and renew automatically.</li>
          <li>You may cancel your subscription at any time; access continues until the end of the current period.</li>
          <li>All payments are in Nigerian Naira (NGN). Prices may change with 30 days' notice.</li>
          <li>Refunds are handled on a case-by-case basis. Contact us within 7 days of a charge for disputes.</li>
        </ul>
      </Section>

      <Section title="6. Virtual Items & XP">
        XP, levels, league mastery progress, and other in-game items have no monetary value and cannot be
        exchanged for real money. We reserve the right to adjust game mechanics at any time.
      </Section>

      <Section title="7. Intellectual Property">
        All content on LeagueIQ — including questions, graphics, and software — is owned by or licensed to
        LeagueIQ. You may not reproduce or distribute it without our written permission.
        League names, crests, and trademarks belong to their respective owners and are used for
        informational/entertainment purposes only. LeagueIQ is not affiliated with any football league or club.
      </Section>

      <Section title="8. Disclaimers">
        LeagueIQ is provided "as is". We make no warranties about uptime, accuracy of trivia content, or
        fitness for any particular purpose. We are not liable for any loss or damage arising from your use
        of the service.
      </Section>

      <Section title="9. Termination">
        We may suspend or terminate your account if you violate these terms. You may delete your account
        at any time from the Profile screen. Upon deletion all your data is permanently erased.
      </Section>

      <Section title="10. Changes to These Terms">
        We may update these terms from time to time. We'll notify you via in-app notice or email.
        Continued use after changes constitutes acceptance of the new terms.
      </Section>

      <Section title="11. Governing Law">
        These terms are governed by the laws of the Federal Republic of Nigeria. Any disputes shall be
        resolved in Nigerian courts.
      </Section>

      <Section title="12. Contact">
        Questions about these terms? Email{' '}
        <a href="mailto:legal@leagueiq.app" className="text-iq-gold hover:underline">legal@leagueiq.app</a>.
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
