import { useState, useEffect, useCallback } from 'react'
import { Shield, X, Mail, Lock, ThumbsDown, Users as UsersIcon, BarChart3, Heart, CheckCircle2 } from 'lucide-react'

const API_BASE = ''

export function AdminPanel({ onClose }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loggedIn, setLoggedIn] = useState(false)
  const [loginError, setLoginError] = useState('')
  const [tab, setTab] = useState('feedback')
  const [feedback, setFeedback] = useState([])
  const [filter, setFilter] = useState(0)
  const [loading, setLoading] = useState(false)
  const [users, setUsers] = useState([])
  const [analytics, setAnalytics] = useState(null)

  const handleLogin = async () => {
    try {
      const res = await fetch(`${API_BASE}/api/admin/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      })
      if (res.ok) {
        setLoggedIn(true)
        setLoginError('')
      } else {
        const data = await res.json()
        setLoginError(data.detail || 'არასწორი ელ-ფოსტა ან პაროლი')
      }
    } catch (e) {
      setLoginError('შეცდომა დაკავშირებისას')
    }
  }

  const fetchFeedback = useCallback(async () => {
    setLoading(true)
    try {
      const res = await fetch(`${API_BASE}/api/feedback?reviewed=${filter}`)
      const data = await res.json()
      setFeedback(data.feedback || [])
    } catch (e) {
      console.error('Failed to fetch feedback:', e)
    }
    setLoading(false)
  }, [filter])

  const fetchUsers = useCallback(async () => {
    setLoading(true)
    try {
      const res = await fetch(`${API_BASE}/api/admin/users`)
      const data = await res.json()
      setUsers(data.users || [])
    } catch (e) {
      console.error('Failed to fetch users:', e)
    }
    setLoading(false)
  }, [])

  const fetchAnalytics = useCallback(async () => {
    setLoading(true)
    try {
      const res = await fetch(`${API_BASE}/api/admin/analytics`)
      const data = await res.json()
      setAnalytics(data)
    } catch (e) {
      console.error('Failed to fetch analytics:', e)
    }
    setLoading(false)
  }, [])

  useEffect(() => {
    if (loggedIn) {
      if (tab === 'feedback') fetchFeedback()
      else if (tab === 'users') fetchUsers()
      else if (tab === 'analytics') fetchAnalytics()
    }
  }, [loggedIn, tab, fetchFeedback, fetchUsers, fetchAnalytics])

  const markReviewed = async (id) => {
    try {
      await fetch(`${API_BASE}/api/feedback/${id}/review`, { method: 'POST' })
      fetchFeedback()
    } catch (e) {
      console.error('Failed to mark reviewed:', e)
    }
  }

  if (!loggedIn) {
    return (
      <div className="fixed inset-0 bg-black/50 modal-backdrop z-50 flex items-center justify-center p-4" onClick={onClose}>
        <div className="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl" onClick={(e) => e.stopPropagation()}>
          <div className="flex items-center justify-between mb-5">
            <div className="flex items-center gap-2">
              <Shield className="w-5 h-5 text-blue-500" />
              <h2 className="text-lg font-bold text-gray-900">ადმინ პანელი</h2>
            </div>
            <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition">
              <X className="w-5 h-5 text-gray-400" />
            </button>
          </div>
          <div className="space-y-3">
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="ელ-ფოსტა"
                className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
                onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
              />
            </div>
            <div className="relative">
              <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="პაროლი"
                className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
                onKeyDown={(e) => e.key === 'Enter' && handleLogin()}
              />
            </div>
            {loginError && <p className="text-sm text-red-500">{loginError}</p>}
            <button
              onClick={handleLogin}
              className="w-full py-2.5 rounded-xl bg-gradient-to-r from-blue-500 to-indigo-600 text-white font-medium hover:shadow-lg hover:shadow-blue-500/20 transition"
            >
              შესვლა
            </button>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="fixed inset-0 bg-black/50 modal-backdrop z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div className="bg-white rounded-3xl max-w-3xl w-full max-h-[90vh] overflow-y-auto shadow-2xl" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between p-5 border-b border-gray-100 sticky top-0 bg-white z-10">
          <div className="flex items-center gap-2">
            <Shield className="w-5 h-5 text-blue-500" />
            <h2 className="text-lg font-bold text-gray-900">ადმინ პანელი</h2>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition">
            <X className="w-5 h-5 text-gray-400" />
          </button>
        </div>

        <div className="flex gap-1 px-5 pt-3 border-b border-gray-100">
          {[
            { id: 'feedback', label: 'ფიდბექი', icon: ThumbsDown },
            { id: 'users', label: 'მომხმარებლები', icon: UsersIcon },
            { id: 'analytics', label: 'ანალიტიკა', icon: BarChart3 },
          ].map(t => (
            <button
              key={t.id}
              onClick={() => setTab(t.id)}
              className={`flex items-center gap-1.5 px-4 py-2.5 rounded-t-xl text-sm font-medium transition ${
                tab === t.id
                  ? 'text-blue-600 border-b-2 border-blue-600 bg-blue-50/50'
                  : 'text-gray-500 hover:text-gray-700 hover:bg-gray-50'
              }`}
            >
              <t.icon className="w-4 h-4" />
              {t.label}
            </button>
          ))}
        </div>

        <div className="p-5">
          {loading ? (
            <div className="flex items-center justify-center py-10">
              <div className="w-8 h-8 border-[3px] border-blue-500 border-t-transparent rounded-full animate-spin"></div>
            </div>
          ) : tab === 'feedback' ? (
            <>
              <div className="flex items-center justify-between mb-4">
                <p className="text-sm text-gray-500">{feedback.length} შეტყობინება</p>
                <button
                  onClick={() => setFilter(filter === 0 ? -1 : 0)}
                  className="px-3 py-1.5 rounded-lg text-sm font-medium border border-gray-200 hover:bg-gray-50 transition"
                >
                  {filter === 0 ? 'ყველა' : 'მხოლოდ ახალი'}
                </button>
              </div>
              {feedback.length === 0 ? (
                <p className="text-center py-10 text-gray-400">ფიდბექი არ არის</p>
              ) : (
                <div className="space-y-3">
                  {feedback.map((f) => (
                    <div key={f.id} className={`rounded-2xl border p-4 ${f.reviewed ? 'border-gray-200 bg-gray-50/50' : 'border-orange-200 bg-orange-50/50'}`}>
                      <div className="flex items-start justify-between gap-3 mb-2">
                        <div className="min-w-0 flex-1">
                          <p className="font-medium text-gray-900 text-sm">
                            {f.display_name || f.match_key}
                          </p>
                          {f.store_name && (
                            <p className="text-xs text-orange-600 mt-1">
                              არასწორი მაღაზია: <b>{f.store_name}</b>
                            </p>
                          )}
                          {f.listing_product_name && (
                            <p className="text-xs text-gray-500 mt-0.5">
                              პროდუქტის სახელი მაღაზიაში: {f.listing_product_name}
                            </p>
                          )}
                          {f.note && (
                            <p className="text-xs text-gray-600 mt-1 bg-white/60 rounded-lg p-2">
                              {f.note}
                            </p>
                          )}
                          <p className="text-[10px] text-gray-400 mt-1">{f.created_at}</p>
                        </div>
                        {!f.reviewed && (
                          <button
                            onClick={() => markReviewed(f.id)}
                            className="px-3 py-1.5 rounded-lg text-xs font-medium bg-green-500 text-white hover:bg-green-600 transition flex-shrink-0"
                          >
                            გადასინჯვა
                          </button>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </>
          ) : tab === 'users' ? (
            <>
              <p className="text-sm text-gray-500 mb-4">{users.length} დარეგისტრირებული მომხმარებელი</p>
              {users.length === 0 ? (
                <p className="text-center py-10 text-gray-400">დარეგისტრირებული მომხმარებელი არ არის</p>
              ) : (
                <div className="space-y-2">
                  {users.map((u) => (
                    <div key={u.id} className="rounded-2xl border border-gray-200 p-4 hover:bg-gray-50/50 transition">
                      <div className="flex items-start justify-between gap-3">
                        <div className="min-w-0 flex-1">
                          <p className="font-medium text-gray-900 text-sm">
                            {u.first_name} {u.last_name}
                          </p>
                          <p className="text-xs text-gray-500 mt-0.5">{u.email}</p>
                          <div className="flex items-center gap-3 mt-1 text-[10px] text-gray-400">
                            <span>რეგ: {u.created_at}</span>
                            {u.last_login && <span>ბოლო შესვლა: {u.last_login}</span>}
                          </div>
                        </div>
                        <div className="flex items-center gap-1 text-xs text-gray-400 flex-shrink-0">
                          <Lock className="w-3 h-3" />
                          <span className="font-mono">{u.password}</span>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </>
          ) : tab === 'analytics' ? (
            <>
              {analytics ? (
                <div>
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
                    <div className="rounded-2xl border border-gray-200 p-4">
                      <p className="text-xs text-gray-500 mb-1">სულ ვიზიტები</p>
                      <p className="text-2xl font-bold text-gray-900">{analytics.total_visits}</p>
                    </div>
                    <div className="rounded-2xl border border-gray-200 p-4">
                      <p className="text-xs text-gray-500 mb-1">უნიკალური IP</p>
                      <p className="text-2xl font-bold text-gray-900">{analytics.unique_ips}</p>
                    </div>
                    <div className="rounded-2xl border border-gray-200 p-4">
                      <p className="text-xs text-gray-500 mb-1">დღეს</p>
                      <p className="text-2xl font-bold text-blue-600">{analytics.today_visits}</p>
                    </div>
                    <div className="rounded-2xl border border-gray-200 p-4">
                      <p className="text-xs text-gray-500 mb-1">რეგ. მომხმარ.</p>
                      <p className="text-2xl font-bold text-indigo-600">{analytics.total_users}</p>
                    </div>
                  </div>

                  {analytics.daily.length > 0 && (
                    <div className="mb-6">
                      <h3 className="text-sm font-semibold text-gray-700 mb-3">ბოლო 7 დღე</h3>
                      <div className="space-y-2">
                        {analytics.daily.map((d) => (
                          <div key={d.day} className="flex items-center gap-3">
                            <span className="text-xs text-gray-500 w-24 flex-shrink-0">{d.day}</span>
                            <div className="flex-1 bg-gray-100 rounded-full h-6 relative overflow-hidden">
                              <div
                                className="bg-gradient-to-r from-blue-500 to-indigo-500 h-full rounded-full"
                                style={{ width: `${Math.min(100, (d.visits / Math.max(...analytics.daily.map(x => x.visits))) * 100)}%` }}
                              ></div>
                              <span className="absolute right-2 top-1/2 -translate-y-1/2 text-xs text-gray-700 font-medium">
                                {d.visits} ({d.unique_ips} უნიკ.)
                              </span>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  <div>
                    <h3 className="text-sm font-semibold text-gray-700 mb-3">ბოლო ვიზიტორები</h3>
                    <div className="space-y-1 max-h-60 overflow-y-auto">
                      {analytics.recent.map((v, i) => (
                        <div key={i} className="flex items-center gap-3 text-xs text-gray-500 py-1.5 border-b border-gray-100">
                          <span className="font-mono text-gray-700">{v.ip || '—'}</span>
                          <span className="truncate flex-1">{v.path}</span>
                          <span className="text-gray-400 flex-shrink-0">{v.created_at}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              ) : (
                <p className="text-center py-10 text-gray-400">მონაცემები იტვირთება...</p>
              )}
            </>
          ) : null}
        </div>
      </div>
    </div>
  )
}

export function AuthModal({ mode, onClose, onSwitchMode, onLogin }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSubmit = async () => {
    if (!email || !password) {
      setError('შეავსეთ ყველა ველი')
      return
    }
    setLoading(true)
    setError('')
    try {
      const endpoint = mode === 'login' ? '/api/auth/login' : '/api/auth/register'
      const body = mode === 'login'
        ? { email, password }
        : { email, password, first_name: firstName, last_name: lastName }
      const res = await fetch(`${API_BASE}${endpoint}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      })
      const data = await res.json()
      if (res.ok) {
        onLogin(data.token, data.user)
      } else {
        setError(data.detail || 'შეცდომა')
      }
    } catch (e) {
      setError('შეცდომა დაკავშირებისას')
    }
    setLoading(false)
  }

  return (
    <div className="fixed inset-0 bg-black/50 modal-backdrop z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div className="bg-white rounded-3xl max-w-sm w-full p-6 shadow-2xl" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between mb-5">
          <h2 className="text-lg font-bold text-gray-900">
            {mode === 'login' ? 'შესვლა' : 'რეგისტრაცია'}
          </h2>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition">
            <X className="w-5 h-5 text-gray-400" />
          </button>
        </div>
        <div className="space-y-3">
          {mode === 'register' && (
            <div className="grid grid-cols-2 gap-2">
              <input
                type="text"
                value={firstName}
                onChange={(e) => setFirstName(e.target.value)}
                placeholder="სახელი"
                className="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
              />
              <input
                type="text"
                value={lastName}
                onChange={(e) => setLastName(e.target.value)}
                placeholder="გვარი"
                className="w-full px-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
              />
            </div>
          )}
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="ელ-ფოსტა"
              className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
              onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
            />
          </div>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="პაროლი"
              className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition"
              onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
            />
          </div>
          {error && <p className="text-sm text-red-500">{error}</p>}
          <button
            onClick={handleSubmit}
            disabled={loading}
            className="w-full py-2.5 rounded-xl bg-gradient-to-r from-blue-500 to-indigo-600 text-white font-medium hover:shadow-lg hover:shadow-blue-500/20 transition disabled:opacity-50"
          >
            {loading ? '...' : mode === 'login' ? 'შესვლა' : 'რეგისტრაცია'}
          </button>
          <p className="text-center text-sm text-gray-500">
            {mode === 'login' ? 'არ გაქვთ ანგარიში? ' : 'უკვე გაქვთ ანგარიში? '}
            <button
              onClick={() => onSwitchMode(mode === 'login' ? 'register' : 'login')}
              className="text-blue-600 hover:underline font-medium"
            >
              {mode === 'login' ? 'რეგისტრაცია' : 'შესვლა'}
            </button>
          </p>
        </div>
      </div>
    </div>
  )
}

export function FavoritesModal({ favorites, onClose, onSelectProduct, onRemoveFavorite, formatPrice, storeColors, ProductCard, lang }) {
  return (
    <div className="fixed inset-0 bg-black/50 modal-backdrop z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl" onClick={(e) => e.stopPropagation()}>
        <div className="flex items-center justify-between p-5 border-b border-gray-100 sticky top-0 bg-white z-10">
          <div className="flex items-center gap-2">
            <Heart className="w-5 h-5 text-red-500" />
            <h2 className="text-lg font-bold text-gray-900">რჩეული პროდუქტები</h2>
            {favorites.length > 0 && <span className="text-sm text-gray-400">({favorites.length})</span>}
          </div>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition">
            <X className="w-5 h-5 text-gray-400" />
          </button>
        </div>
        <div className="p-5">
          {favorites.length === 0 ? (
            <div className="text-center py-12">
              <Heart className="w-12 h-12 text-gray-200 mx-auto mb-3" />
              <p className="text-gray-400">რჩეული პროდუქტები არ არის</p>
              <p className="text-sm text-gray-300 mt-1">დაამატეთ პროდუქტები გულის ხატულაზე დაჭერით</p>
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
              {favorites.map((product) => (
                <ProductCard
                  key={product.match_key}
                  product={product}
                  onClick={() => onSelectProduct(product)}
                  formatPrice={formatPrice}
                  storeColors={storeColors}
                  isFavorite={true}
                  onToggleFavorite={() => onRemoveFavorite(product.match_key)}
                  lang={lang}
                />
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
