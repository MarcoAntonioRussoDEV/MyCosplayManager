import { useEffect, useRef, useState } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { ApiError } from '../api'

// Stesso client OAuth "Web" gia' creato per il backend/app mobile (verifica ID token
// lato server): qui serve anche come Authorized JavaScript origin per questo host.
const GOOGLE_CLIENT_ID =
  import.meta.env.VITE_GOOGLE_CLIENT_ID ?? '408728346093-6csufctkpk1rk5b6dc3iqprm58g94n3l.apps.googleusercontent.com'

export function LoginPage() {
  const { isAuthenticated, loginWithGoogle } = useAuth()
  const [error, setError] = useState<string | null>(null)
  const buttonRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (isAuthenticated) return

    let cancelled = false
    const tryInit = () => {
      if (cancelled) return
      if (!window.google || !buttonRef.current) {
        setTimeout(tryInit, 100)
        return
      }
      window.google.accounts.id.initialize({
        client_id: GOOGLE_CLIENT_ID,
        callback: async (response) => {
          setError(null)
          try {
            await loginWithGoogle(response.credential)
          } catch (err) {
            setError(err instanceof ApiError ? err.message : 'Errore di connessione')
          }
        },
      })
      window.google.accounts.id.renderButton(buttonRef.current, {
        theme: 'filled_blue',
        size: 'large',
        width: 300,
        text: 'signin_with',
      })
    }
    tryInit()
    return () => {
      cancelled = true
    }
  }, [isAuthenticated, loginWithGoogle])

  if (isAuthenticated) return <Navigate to="/" replace />

  return (
    <div className="login-page">
      <div className="card login-card" style={{ textAlign: 'center' }}>
        <h1 style={{ fontSize: '1.3rem' }}>My Cosplay Manager Admin</h1>
        <p style={{ color: 'var(--text-muted)', fontSize: '0.85rem' }}>
          Accesso riservato agli account autorizzati.
        </p>
        {error && <p className="error-text">{error}</p>}
        <div ref={buttonRef} style={{ display: 'flex', justifyContent: 'center', marginTop: 12 }} />
      </div>
    </div>
  )
}
