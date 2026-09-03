import { useEffect, useState } from 'react'
import { api, ApiError } from '../api'
import type { Stats } from '../types'

export function DashboardPage() {
  const [stats, setStats] = useState<Stats | null>(null)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    api
      .get<Stats>('/api/admin/stats')
      .then(setStats)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }, [])

  return (
    <div>
      <div className="page-header">
        <h2>Dashboard</h2>
      </div>
      {error && <p className="error-text">{error}</p>}
      {stats && (
        <div className="stat-grid">
          <div className="stat-card">
            <div className="value">{stats.userCount}</div>
            <div className="label">Utenti</div>
          </div>
          <div className="stat-card">
            <div className="value">{stats.teamCount}</div>
            <div className="label">Laboratori</div>
          </div>
          <div className="stat-card">
            <div className="value">{stats.productCount}</div>
            <div className="label">Prodotti a catalogo</div>
          </div>
          <div className="stat-card">
            <div className="value">{stats.inventoryItemCount}</div>
            <div className="label">Articoli in inventario</div>
          </div>
        </div>
      )}
    </div>
  )
}
