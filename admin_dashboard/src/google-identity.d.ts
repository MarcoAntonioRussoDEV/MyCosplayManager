// Tipi minimi per Google Identity Services (script caricato da index.html, nessun
// pacchetto npm ufficiale): solo cio' che usiamo davvero (login con ID token).
interface GoogleCredentialResponse {
  credential: string
}

interface GoogleAccountsId {
  initialize(config: { client_id: string; callback: (response: GoogleCredentialResponse) => void }): void
  renderButton(parent: HTMLElement, options: Record<string, unknown>): void
  prompt(): void
}

interface Window {
  google?: {
    accounts: {
      id: GoogleAccountsId
    }
  }
}
