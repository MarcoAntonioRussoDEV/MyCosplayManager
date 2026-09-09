import { useState, type ChangeEvent, type FormEvent } from 'react'
import { api, ApiError } from '../api'

export function NotificationsPage() {
  const [title, setTitle] = useState('')
  const [body, setBody] = useState('')
  const [email, setEmail] = useState('')
  const [sending, setSending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [result, setResult] = useState<string | null>(null)

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()
    setSending(true)
    setError(null)
    setResult(null)
    try {
      const response = await api.post<{ sentCount: number }>('/api/admin/notifications/send', {
        title,
        body,
        email: email.trim() || undefined,
      })
      setResult(
        response.sentCount === 0
          ? 'Nessun dispositivo raggiunto (nessun token registrato per il target scelto).'
          : `Notifica inviata a ${response.sentCount} dispositivo/i.`,
      )
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setSending(false)
    }
  }

  return (
    <div>
      <div className="page-header">
        <h2>Notifiche</h2>
      </div>
      <p style={{ color: 'var(--text-muted)', marginTop: -8 }}>
        Invia una push a comando, con testo libero. Utile per testare la pipeline senza aspettare uno scheduler.
      </p>
      <form onSubmit={handleSubmit} style={{ maxWidth: 480 }}>
        <div className="field">
          <label htmlFor="title">Titolo</label>
          <input
            id="title"
            value={title}
            onChange={(e: ChangeEvent<HTMLInputElement>) => setTitle(e.target.value)}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="body">Testo</label>
          <textarea
            id="body"
            value={body}
            onChange={(e: ChangeEvent<HTMLTextAreaElement>) => setBody(e.target.value)}
            required
            rows={3}
          />
        </div>
        <div className="field">
          <label htmlFor="email">Email destinatario (vuoto = tutti i dispositivi)</label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e: ChangeEvent<HTMLInputElement>) => setEmail(e.target.value)}
            placeholder="lascia vuoto per broadcast a tutti"
          />
        </div>
        {error && <p className="error-text">{error}</p>}
        {result && <p className="success-text">{result}</p>}
        <button className="btn" type="submit" disabled={sending} style={{ width: '100%' }}>
          {sending ? 'Invio...' : 'Invia notifica'}
        </button>
      </form>
    </div>
  )
}
