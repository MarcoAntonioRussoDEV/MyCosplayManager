import { useEffect, useState } from 'react'
import { api, ApiError } from '../api'
import type { AdminTeam } from '../types'

export function TeamsPage() {
  const [teams, setTeams] = useState<AdminTeam[]>([])
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    api
      .get<AdminTeam[]>('/api/admin/teams')
      .then(setTeams)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }, [])

  return (
    <div>
      <div className="page-header">
        <h2>Laboratori</h2>
      </div>
      {error && <p className="error-text">{error}</p>}
      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Codice invito</th>
            <th>Membri</th>
          </tr>
        </thead>
        <tbody>
          {teams.map((team) => (
            <tr key={team.id}>
              <td data-label="Nome">{team.name}</td>
              <td data-label="Codice invito">
                <code>{team.inviteCode}</code>
              </td>
              <td data-label="Membri">{team.memberCount}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
