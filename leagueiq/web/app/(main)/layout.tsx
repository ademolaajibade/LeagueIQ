import Nav from '@/components/Nav'

export default function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen" style={{ background: '#080B14' }}>
      <Nav />
      <main className="pb-20 md:pb-0">
        {children}
      </main>
    </div>
  )
}
