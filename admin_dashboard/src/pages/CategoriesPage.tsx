import { useEffect, useState, type ChangeEvent, type FormEvent } from 'react'
import { api, ApiError } from '../api'
import type { Category } from '../types'
import { Modal } from '../components/Modal'

type CategoryForm = { code: string; nameIt: string; nameEn: string; nameEs: string; nameFr: string }
const emptyForm: CategoryForm = { code: '', nameIt: '', nameEn: '', nameEs: '', nameFr: '' }

export function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([])
  const [error, setError] = useState<string | null>(null)
  const [editing, setEditing] = useState<Category | null>(null)
  const [creating, setCreating] = useState(false)

  const load = () => {
    api
      .get<Category[]>('/api/admin/categories')
      .then(setCategories)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }

  useEffect(load, [])

  const remove = async (category: Category) => {
    if (!confirm(`Eliminare "${category.nameIt}"? Fallisce se ci sono ancora prodotti in questa categoria.`)) return
    try {
      await api.delete(`/api/admin/categories/${category.id}`)
      setCategories((prev) => prev.filter((c) => c.id !== category.id))
    } catch (err) {
      alert(err instanceof ApiError ? err.message : 'Errore di connessione')
    }
  }

  return (
    <div>
      <div className="page-header">
        <h2>Categorie</h2>
        <button className="btn" onClick={() => setCreating(true)}>
          + Nuova
        </button>
      </div>
      {error && <p className="error-text">{error}</p>}
      <table className="data-table">
        <thead>
          <tr>
            <th>Codice</th>
            <th>Italiano</th>
            <th>Inglese</th>
            <th>Azioni</th>
          </tr>
        </thead>
        <tbody>
          {categories.map((category) => (
            <tr key={category.id}>
              <td data-label="Codice">
                <code>{category.code}</code>
              </td>
              <td data-label="Italiano">{category.nameIt}</td>
              <td data-label="Inglese">{category.nameEn}</td>
              <td data-label="Azioni">
                <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
                  <button className="btn secondary" onClick={() => setEditing(category)}>
                    Modifica
                  </button>
                  <button className="btn danger" onClick={() => remove(category)}>
                    Elimina
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {editing && (
        <CategoryFormModal
          title={`Modifica: ${editing.nameIt}`}
          initial={editing}
          codeReadOnly
          onClose={() => setEditing(null)}
          onSubmit={async (form) => {
            const updated = await api.put<Category>(`/api/admin/categories/${editing.id}`, form)
            setCategories((prev) => prev.map((c) => (c.id === updated.id ? updated : c)))
            setEditing(null)
          }}
        />
      )}

      {creating && (
        <CategoryFormModal
          title="Nuova categoria"
          initial={emptyForm}
          codeReadOnly={false}
          onClose={() => setCreating(false)}
          onSubmit={async (form) => {
            const created = await api.post<Category>('/api/admin/categories', form)
            setCategories((prev) => [...prev, created])
            setCreating(false)
          }}
        />
      )}
    </div>
  )
}

function CategoryFormModal({
  title,
  initial,
  codeReadOnly,
  onClose,
  onSubmit,
}: {
  title: string
  initial: CategoryForm
  codeReadOnly: boolean
  onClose: () => void
  onSubmit: (form: CategoryForm) => Promise<void>
}) {
  const [form, setForm] = useState<CategoryForm>(initial)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const field = (key: keyof CategoryForm) => ({
    value: form[key],
    onChange: (e: ChangeEvent<HTMLInputElement>) => setForm((f) => ({ ...f, [key]: e.target.value })),
  })

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    try {
      await onSubmit(form)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setSaving(false)
    }
  }

  return (
    <Modal title={title} onClose={onClose}>
      <form onSubmit={handleSubmit}>
        <div className="field">
          <label htmlFor="code">Codice</label>
          <input id="code" {...field('code')} required disabled={codeReadOnly} />
        </div>
        <div className="field">
          <label htmlFor="nameIt">Italiano</label>
          <input id="nameIt" {...field('nameIt')} required />
        </div>
        <div className="field">
          <label htmlFor="nameEn">Inglese</label>
          <input id="nameEn" {...field('nameEn')} required />
        </div>
        <div className="field">
          <label htmlFor="nameEs">Spagnolo</label>
          <input id="nameEs" {...field('nameEs')} required />
        </div>
        <div className="field">
          <label htmlFor="nameFr">Francese</label>
          <input id="nameFr" {...field('nameFr')} required />
        </div>
        {error && <p className="error-text">{error}</p>}
        <button className="btn" type="submit" disabled={saving} style={{ width: '100%' }}>
          {saving ? 'Salvataggio...' : 'Salva'}
        </button>
      </form>
    </Modal>
  )
}
