import type { ReactNode } from 'react'
import { NavLink } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'

const NAV_ITEMS = [
  { to: '/', label: 'Home', icon: '📊', end: true },
  { to: '/users', label: 'Utenti', icon: '👤' },
  { to: '/teams', label: 'Team', icon: '🧑‍🤝‍🧑' },
  { to: '/products', label: 'Prodotti', icon: '📦' },
  { to: '/categories', label: 'Categorie', icon: '🏷️' },
  { to: '/notifications', label: 'Notifiche', icon: '🔔' },
]

export function AppShell({ children }: { children: ReactNode }) {
  const { email, logout } = useAuth()

  return (
    <div className="app-shell">
      <nav className="bottom-nav" aria-label="Navigazione principale">
        {NAV_ITEMS.map((item) => (
          <NavLink
            key={item.to}
            to={item.to}
            end={item.end}
            className={({ isActive }) => (isActive ? 'active' : '')}
          >
            <span className="icon" aria-hidden>
              {item.icon}
            </span>
            <span>{item.label}</span>
          </NavLink>
        ))}
      </nav>
      <div className="app-main">
        <header className="app-topbar">
          <h1>My Cosplay Manager Admin</h1>
          <button className="btn secondary" onClick={logout} aria-label={`Esci (${email})`}>
            Esci
          </button>
        </header>
        <main className="app-content">{children}</main>
      </div>
    </div>
  )
}
