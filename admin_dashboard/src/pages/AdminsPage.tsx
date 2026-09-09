import { useEffect, useState, type ChangeEvent, type FormEvent } from 'react'
import { api, ApiError } from '../api'
import type { AdminEmail } from '../types'

export function AdminsPage() {
  const [admins, setAdmins] = useState<AdminEmail[]>([])
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [adding, setAdding] = useState(false)
  const [busyId, setBusyId] = useState<string | null>(null)

  const load = () => {
    api
      .get<AdminEmail[]>('/api/admin/admins')
      .then(setAdmins)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }

  useEffect(load, [])

  const handleAdd = async (e: FormEvent) => {
    e.preventDefault()
    setAdding(true)
    setError(null)
    try {
      const created = await api.post<AdminEmail>('/api/admin/admins', { email: email.trim() })
      setAdmins((prev) => [...prev, created])
      setEmail('')
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setAdding(false)
    }
  }

  const remove = async (admin: AdminEmail) => {
    if (!confirm(`Rimuovere l'accesso admin per ${admin.email}?`)) return
    setBusyId(admin.id)
    try {
      await api.delete(`/api/admin/admins/${admin.id}`)
      setAdmins((prev) => prev.filter((a) => a.id !== admin.id))
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setBusyId(null)
    }
  }

  return (
    <div>
      <div className="page-header">
        <h2>Admin</h2>
      </div>
      <p style={{ color: 'var(--text-muted)', marginTop: -8 }}>
        Email autorizzate ad accedere a questa dashboard via Google. Ricontrollata a ogni richiesta.
      </p>
      <form onSubmit={handleAdd} style={{ display: 'flex', gap: 8, maxWidth: 480, marginBottom: 20 }}>
        <input
          type="email"
          value={email}
          onChange={(e: ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)}
          placeholder="nuovo-admin@gmail.com"
          required
          style={{ flex: 1 }}
        />
        <button className="btn" type="submit" disabled={adding}>
          {adding ? 'Aggiunta...' : '+ Aggiungi'}
        </button>
      </form>
      {error && <p className="error-text">{error}</p>}
      <table className="data-table">
        <thead>
          <tr>
            <th>Email</th>
            <th>Autorizzato dal</th>
            <th>Azioni</th>
          </tr>
        </thead>
        <tbody>
          {admins.map((admin) => (
            <tr key={admin.id}>
              <td data-label="Email">{admin.email}</td>
              <td data-label="Autorizzato dal">{new Date(admin.createdAt).toLocaleDateString('it-IT')}</td>
              <td data-label="Azioni">
                <button
                  className="btn danger"
                  disabled={busyId === admin.id || admins.length <= 1}
                  title={admins.length <= 1 ? "Non puoi rimuovere l'ultimo admin" : undefined}
                  onClick={() => remove(admin)}
                >
                  Rimuovi
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
