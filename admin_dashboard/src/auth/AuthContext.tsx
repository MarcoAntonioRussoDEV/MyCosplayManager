import { createContext, useContext, useEffect, useState, type ReactNode } from 'react'
import { api, getToken, setToken } from '../api'

interface AdminAuthResponse {
  email: string
  token: string
}

interface AuthState {
  email: string | null
  isAuthenticated: boolean
  loginWithGoogle: (idToken: string) => Promise<void>
  logout: () => void
}

const AuthContext = createContext<AuthState | null>(null)

const EMAIL_KEY = 'admin_email'

export function AuthProvider({ children }: { children: ReactNode }) {
  const [email, setEmail] = useState<string | null>(() => (getToken() ? localStorage.getItem(EMAIL_KEY) : null))

  useEffect(() => {
    // Il client API lo emette su qualunque 401: cosi' un token scaduto (o un'email
    // tolta dalla whitelist) durante l'uso normale riporta al login.
    const onUnauthorized = () => setEmail(null)
    window.addEventListener('admin-unauthorized', onUnauthorized)
    return () => window.removeEventListener('admin-unauthorized', onUnauthorized)
  }, [])

  const loginWithGoogle = async (idToken: string) => {
    const response = await api.post<AdminAuthResponse>('/api/admin/auth/google', { idToken })
    setToken(response.token)
    localStorage.setItem(EMAIL_KEY, response.email)
    setEmail(response.email)
  }

  const logout = () => {
    setToken(null)
    localStorage.removeItem(EMAIL_KEY)
    setEmail(null)
  }

  return (
    <AuthContext.Provider value={{ email, isAuthenticated: email !== null, loginWithGoogle, logout }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth(): AuthState {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth used outside AuthProvider')
  return ctx
}
