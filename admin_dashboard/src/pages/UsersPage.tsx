import { useEffect, useState } from 'react'
import { api, ApiError } from '../api'
import type { AdminUser } from '../types'

export function UsersPage() {
  const [users, setUsers] = useState<AdminUser[]>([])
  const [error, setError] = useState<string | null>(null)
  const [busyId, setBusyId] = useState<string | null>(null)

  const load = () => {
    api
      .get<AdminUser[]>('/api/admin/users')
      .then(setUsers)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }

  useEffect(load, [])

  const toggleBanned = async (user: AdminUser) => {
    setBusyId(user.id)
    try {
      const updated = await api.patch<AdminUser>(`/api/admin/users/${user.id}/banned`, {
        banned: !user.banned,
      })
      setUsers((prev) => prev.map((u) => (u.id === updated.id ? updated : u)))
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setBusyId(null)
    }
  }

  return (
    <div>
      <div className="page-header">
        <h2>Utenti</h2>
      </div>
      {error && <p className="error-text">{error}</p>}
      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Email</th>
            <th>Laboratorio</th>
            <th>Stato</th>
            <th>Azioni</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td data-label="Nome">{user.name}</td>
              <td data-label="Email">{user.email}</td>
              <td data-label="Laboratorio">{user.teamName}</td>
              <td data-label="Stato">
                <span className={`badge ${user.banned ? 'danger' : 'success'}`}>
                  {user.banned ? 'Sospeso' : 'Attivo'}
                </span>
              </td>
              <td data-label="Azioni">
                <button
                  className={`btn ${user.banned ? 'secondary' : 'danger'}`}
                  disabled={busyId === user.id}
                  onClick={() => toggleBanned(user)}
                >
                  {user.banned ? 'Riattiva' : 'Sospendi'}
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
