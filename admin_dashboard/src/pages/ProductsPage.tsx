import { useEffect, useState, type FormEvent } from 'react'
import { api, ApiError } from '../api'
import type { Category, Product } from '../types'
import { Modal } from '../components/Modal'

export function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [error, setError] = useState<string | null>(null)
  const [editing, setEditing] = useState<Product | null>(null)

  const load = () => {
    api
      .get<Product[]>('/api/admin/products')
      .then(setProducts)
      .catch((err) => setError(err instanceof ApiError ? err.message : 'Errore di connessione'))
  }

  useEffect(() => {
    load()
    api.get<Category[]>('/api/admin/categories').then(setCategories).catch(() => {})
  }, [])

  const categoryName = (id: string | null) => categories.find((c) => c.id === id)?.nameIt ?? '—'

  const remove = async (product: Product) => {
    if (!confirm(`Eliminare "${product.name}"? Fallisce se e' ancora in uso in qualche inventario.`)) return
    try {
      await api.delete(`/api/admin/products/${product.id}`)
      setProducts((prev) => prev.filter((p) => p.id !== product.id))
    } catch (err) {
      alert(err instanceof ApiError ? err.message : 'Errore di connessione')
    }
  }

  return (
    <div>
      <div className="page-header">
        <h2>Prodotti</h2>
      </div>
      {error && <p className="error-text">{error}</p>}
      <table className="data-table">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Marca</th>
            <th>Barcode</th>
            <th>Categoria</th>
            <th>Azioni</th>
          </tr>
        </thead>
        <tbody>
          {products.map((product) => (
            <tr key={product.id}>
              <td data-label="Nome">{product.name}</td>
              <td data-label="Marca">{product.brand ?? '—'}</td>
              <td data-label="Barcode">
                <code>{product.barcode}</code>
              </td>
              <td data-label="Categoria">{categoryName(product.categoryId)}</td>
              <td data-label="Azioni">
                <div style={{ display: 'flex', gap: 8, justifyContent: 'flex-end' }}>
                  <button className="btn secondary" onClick={() => setEditing(product)}>
                    Modifica
                  </button>
                  <button className="btn danger" onClick={() => remove(product)}>
                    Elimina
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {editing && (
        <EditProductModal
          product={editing}
          categories={categories}
          onClose={() => setEditing(null)}
          onSaved={(updated) => {
            setProducts((prev) => prev.map((p) => (p.id === updated.id ? updated : p)))
            setEditing(null)
          }}
        />
      )}
    </div>
  )
}

function EditProductModal({
  product,
  categories,
  onClose,
  onSaved,
}: {
  product: Product
  categories: Category[]
  onClose: () => void
  onSaved: (product: Product) => void
}) {
  const [name, setName] = useState(product.name)
  const [brand, setBrand] = useState(product.brand ?? '')
  const [categoryId, setCategoryId] = useState(product.categoryId ?? '')
  const [daysAfterOpening, setDaysAfterOpening] = useState(product.daysAfterOpening?.toString() ?? '')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const onSubmit = async (e: FormEvent) => {
    e.preventDefault()
    setSaving(true)
    setError(null)
    try {
      const updated = await api.put<Product>(`/api/admin/products/${product.id}`, {
        name,
        brand: brand || null,
        categoryId: categoryId || null,
        daysAfterOpening: daysAfterOpening ? Number(daysAfterOpening) : null,
      })
      onSaved(updated)
    } catch (err) {
      setError(err instanceof ApiError ? err.message : 'Errore di connessione')
    } finally {
      setSaving(false)
    }
  }

  return (
    <Modal title={`Modifica: ${product.name}`} onClose={onClose}>
      <form onSubmit={onSubmit}>
        <div className="field">
          <label htmlFor="name">Nome</label>
          <input id="name" value={name} onChange={(e) => setName(e.target.value)} required />
        </div>
        <div className="field">
          <label htmlFor="brand">Marca</label>
          <input id="brand" value={brand} onChange={(e) => setBrand(e.target.value)} />
        </div>
        <div className="field">
          <label htmlFor="category">Categoria</label>
          <select id="category" value={categoryId} onChange={(e) => setCategoryId(e.target.value)}>
            <option value="">—</option>
            {categories.map((c) => (
              <option key={c.id} value={c.id}>
                {c.nameIt}
              </option>
            ))}
          </select>
        </div>
        <div className="field">
          <label htmlFor="days">Giorni dopo l'apertura</label>
          <input
            id="days"
            type="number"
            min={0}
            value={daysAfterOpening}
            onChange={(e) => setDaysAfterOpening(e.target.value)}
          />
        </div>
        {error && <p className="error-text">{error}</p>}
        <button className="btn" type="submit" disabled={saving} style={{ width: '100%' }}>
          {saving ? 'Salvataggio...' : 'Salva'}
        </button>
      </form>
    </Modal>
  )
}
