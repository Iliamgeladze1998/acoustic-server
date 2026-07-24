import { useState, useEffect, useCallback, useRef } from 'react'
import { HashRouter, Routes, Route, useNavigate, useParams, useLocation } from 'react-router-dom'
import { Search, Music, Store, TrendingDown, AlertCircle, X, ExternalLink, CheckCircle2, ThumbsDown, Shield, LogOut, Mail, Lock, ChevronRight, Heart, User, UserPlus, BarChart3, Users as UsersIcon, Eye, Globe } from 'lucide-react'
import { AdminPanel, AuthModal, FavoritesModal } from './components'
import { translations, getLang, setLang, t } from './i18n'

const API_BASE = ''

function LogoIcon({ className = 'w-6 h-6 text-white' }) {
  return (
    <svg viewBox="0 0 48 48" fill="none" className={className} xmlns="http://www.w3.org/2000/svg">
      <rect x="6" y="18" width="6" height="24" rx="3" fill="currentColor" opacity="0.55"/>
      <rect x="15" y="10" width="6" height="32" rx="3" fill="currentColor" opacity="0.75"/>
      <rect x="24" y="20" width="6" height="22" rx="3" fill="currentColor" opacity="0.55"/>
      <rect x="33" y="6" width="6" height="36" rx="3" fill="currentColor"/>
      <circle cx="9" cy="15" r="3.5" fill="currentColor"/>
      <circle cx="18" cy="7" r="3.5" fill="currentColor"/>
      <circle cx="27" cy="17" r="3.5" fill="currentColor"/>
      <circle cx="36" cy="3" r="3.5" fill="currentColor"/>
    </svg>
  )
}

function getImageSrc(imageUrl) {
  // All images are linked directly from the original stores; no local download or proxy.
  return imageUrl || ''
}

function App() {
  const navigate = useNavigate()
  const location = useLocation()
  const [query, setQuery] = useState('')
  const [products, setProducts] = useState([])
  const [total, setTotal] = useState(0)
  const [loading, setLoading] = useState(false)
  const [stores, setStores] = useState([])
  const [selectedStore, setSelectedStore] = useState('')
  const [sortBy, setSortBy] = useState('stores_desc')
  const [stats, setStats] = useState(null)
  const [selectedProduct, setSelectedProduct] = useState(null)
  const [feedbackMsg, setFeedbackMsg] = useState('')
  const [suggestions, setSuggestions] = useState([])
  const [showSuggestions, setShowSuggestions] = useState(false)
  const [highlightedSuggestion, setHighlightedSuggestion] = useState(-1)
  const searchRef = useRef(null)
  const [currentPage, setCurrentPage] = useState(1)
  const [showAdmin, setShowAdmin] = useState(false)
  const [showAuth, setShowAuth] = useState(false)
  const [authMode, setAuthMode] = useState('login')
  const [user, setUser] = useState(null)
  const [userToken, setUserToken] = useState(localStorage.getItem('mc_token') || '')
  const [favorites, setFavorites] = useState(new Set())
  const [showFavorites, setShowFavorites] = useState(false)
  const [favoritesList, setFavoritesList] = useState([])
  const [lang, setLangState] = useState(getLang())
  const [showLangMenu, setShowLangMenu] = useState(false)
  const PAGE_SIZE = 24

  const tt = (key, params) => t(key, lang, params)

  const changeLang = (newLang) => {
    setLang(newLang)
    setLangState(newLang)
    setShowLangMenu(false)
  }

  const fetchStores = useCallback(async () => {
    try {
      const res = await fetch(`${API_BASE}/api/stores`)
      const data = await res.json()
      setStores(data.stores || [])
    } catch (e) {
      console.error('Failed to fetch stores:', e)
    }
  }, [])

  const fetchStats = useCallback(async () => {
    try {
      const res = await fetch(`${API_BASE}/api/stats`)
      const data = await res.json()
      setStats(data)
    } catch (e) {
      console.error('Failed to fetch stats:', e)
    }
  }, [])

  const search = useCallback(async () => {
    setLoading(true)
    try {
      const offset = (currentPage - 1) * PAGE_SIZE
      const params = new URLSearchParams({
        q: query,
        sort: sortBy,
        limit: PAGE_SIZE,
        offset: offset,
      })
      if (selectedStore) params.set('store', selectedStore)
      const res = await fetch(`${API_BASE}/api/search?${params}`)
      const data = await res.json()
      setProducts(data.products || [])
      setTotal(data.total || 0)
    } catch (e) {
      console.error('Search failed:', e)
    } finally {
      setLoading(false)
    }
  }, [query, sortBy, selectedStore, currentPage])

  // Sync URL with search state
  useEffect(() => {
    const params = new URLSearchParams()
    if (query) params.set('q', query)
    if (selectedStore) params.set('store', selectedStore)
    if (sortBy !== 'stores_desc') params.set('sort', sortBy)
    if (currentPage > 1) params.set('page', String(currentPage))
    const qs = params.toString()
    const newPath = qs ? `/?${qs}` : '/'
    if (location.pathname !== newPath && !location.pathname.startsWith('/product/')) {
      navigate(newPath)
    }
  }, [query, selectedStore, sortBy, currentPage, location.pathname, navigate])

  // Parse URL on first load
  useEffect(() => {
    const search = new URLSearchParams(location.search)
    const q = search.get('q') || ''
    const store = search.get('store') || ''
    const sort = search.get('sort') || 'stores_desc'
    const page = parseInt(search.get('page') || '1')
    if (q) setQuery(q)
    if (store) setSelectedStore(store)
    if (sort) setSortBy(sort)
    if (page > 1) setCurrentPage(page)
  }, [])

  useEffect(() => {
    fetchStores()
    fetchStats()
  }, [fetchStores, fetchStats])

  // Hidden admin access via URL hash
  useEffect(() => {
    if (location.hash === '#/admin' || location.pathname === '/admin') {
      setShowAdmin(true)
      navigate('/')
    }
  }, [location.hash, location.pathname, navigate])

  // Load product from URL (direct link)
  useEffect(() => {
    const match = location.pathname.match(/^\/product\/(.+)$/)
    if (match && !selectedProduct) {
      const matchKey = decodeURIComponent(match[1])
      fetch(`${API_BASE}/api/product/${matchKey}`)
        .then(res => res.ok ? res.json() : null)
        .then(data => {
          if (data) setSelectedProduct(data)
        })
        .catch(() => {})
    }
  }, [location.pathname])

  // Auto-login from stored token
  useEffect(() => {
    if (userToken) {
      fetch(`${API_BASE}/api/auth/me?token=${userToken}`)
        .then(res => res.ok ? res.json() : null)
        .then(data => {
          if (data?.user) {
            setUser(data.user)
            loadFavorites(userToken)
          } else {
            localStorage.removeItem('mc_token')
            setUserToken('')
          }
        })
        .catch(() => {})
    }
  }, [])

  const loadFavorites = async (token) => {
    try {
      const res = await fetch(`${API_BASE}/api/favorites/list?token=${token}`)
      if (res.ok) {
        const data = await res.json()
        setFavoritesList(data.favorites || [])
        setFavorites(new Set((data.favorites || []).map(f => f.match_key)))
      }
    } catch (e) {
      console.error('Failed to load favorites:', e)
    }
  }

  const toggleFavorite = async (matchKey) => {
    if (!userToken) {
      setShowAuth(true)
      setAuthMode('login')
      return
    }
    const isFav = favorites.has(matchKey)
    setFavorites(prev => {
      const next = new Set(prev)
      if (isFav) next.delete(matchKey)
      else next.add(matchKey)
      return next
    })
    try {
      await fetch(`${API_BASE}/api/favorites/${isFav ? 'remove' : 'add'}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token: userToken, match_key: matchKey }),
      })
      loadFavorites(userToken)
    } catch (e) {
      console.error('Favorite toggle failed:', e)
    }
  }

  const handleLogout = () => {
    localStorage.removeItem('mc_token')
    setUserToken('')
    setUser(null)
    setFavorites(new Set())
    setFavoritesList([])
  }

  // Fetch autocomplete suggestions
  useEffect(() => {
    if (query.length < 2) {
      setSuggestions([])
      return
    }
    const timer = setTimeout(async () => {
      try {
        const res = await fetch(`${API_BASE}/api/suggestions?q=${encodeURIComponent(query)}&limit=8`)
        const data = await res.json()
        setSuggestions(data.suggestions || [])
        setShowSuggestions(true)
        setHighlightedSuggestion(-1)
      } catch (e) {
        console.error('Suggestions failed:', e)
      }
    }, 200)
    return () => clearTimeout(timer)
  }, [query])

  const handleSuggestionClick = (suggestion) => {
    setQuery(suggestion.display_name)
    setShowSuggestions(false)
    setSuggestions([])
  }

  const handleSearchKeyDown = (e) => {
    if (!showSuggestions || suggestions.length === 0) return
    if (e.key === 'ArrowDown') {
      e.preventDefault()
      setHighlightedSuggestion(prev => Math.min(prev + 1, suggestions.length - 1))
    } else if (e.key === 'ArrowUp') {
      e.preventDefault()
      setHighlightedSuggestion(prev => Math.max(prev - 1, -1))
    } else if (e.key === 'Enter' && highlightedSuggestion >= 0) {
      e.preventDefault()
      handleSuggestionClick(suggestions[highlightedSuggestion])
    } else if (e.key === 'Escape') {
      setShowSuggestions(false)
    }
  }

  // Reset to page 1 when query/sort/store changes
  useEffect(() => {
    setCurrentPage(1)
  }, [query, sortBy, selectedStore])

  useEffect(() => {
    const timer = setTimeout(() => {
      search()
    }, 300)
    return () => clearTimeout(timer)
  }, [search])

  const handleFeedback = async (matchKey, storeName, listingProductName, note) => {
    try {
      const res = await fetch(`${API_BASE}/api/feedback`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          match_key: matchKey,
          store_name: storeName || '',
          listing_product_name: listingProductName || '',
          note: note || '',
        }),
      })
      const data = await res.json()
      if (data.status === 'reported') {
        setFeedbackMsg('გმადლობთ! შეტყობინება მიღებულია.')
      } else if (data.status === 'already_reported') {
        setFeedbackMsg('ეს პროდუქტი უკვე მონიშნულია.')
      }
      setTimeout(() => setFeedbackMsg(''), 3000)
    } catch (e) {
      console.error('Feedback failed:', e)
    }
  }

  const goHome = () => {
    setQuery('')
    setSelectedStore('')
    setSortBy('stores_desc')
    setCurrentPage(1)
    setSelectedProduct(null)
    navigate('/')
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  const formatPrice = (price) => {
    if (price === null || price === undefined) return '—'
    return `${price.toFixed(0)} ₾`
  }

  const storeColors = {
    'Acoustic': 'bg-blue-500',
    'Geovoice': 'bg-purple-500',
    'JinoMusic': 'bg-green-500',
    'Largo': 'bg-orange-500',
    'Mireli': 'bg-pink-500',
    'Musicroom': 'bg-teal-500',
    'Musikis-Saxli': 'bg-indigo-500',
  }

  return (
    <div className="min-h-screen bg-[#f8f9fb]">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-md border-b border-gray-200/60 sticky top-0 z-20">
        <div className="max-w-6xl mx-auto px-4 py-3">
          <div
            className="flex items-center gap-3 mb-3 select-none"
          >
            <div
              className="flex items-center gap-3 cursor-pointer group flex-1 min-w-0"
              onClick={goHome}
            >
              <div className="w-10 h-10 md:w-11 md:h-11 bg-gradient-to-br from-blue-500 via-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-500/20 group-hover:scale-105 group-hover:shadow-blue-500/30 transition-all duration-300 flex-shrink-0">
                <LogoIcon className="w-5 h-5 md:w-6 md:h-6 text-white" />
              </div>
              <div className="min-w-0">
                <h1 className="text-lg md:text-xl font-bold text-gray-900 group-hover:text-blue-600 transition tracking-tight">MusicCompare</h1>
                <p className="text-[10px] md:text-xs text-gray-500 tracking-wide truncate">{tt('tagline')}</p>
              </div>
            </div>
            {/* User controls */}
            <div className="flex items-center gap-2 flex-shrink-0">
              {/* Language switcher */}
              <div className="relative">
                <button
                  onClick={() => setShowLangMenu(!showLangMenu)}
                  className="flex items-center gap-1 px-2.5 py-1.5 rounded-xl text-sm text-gray-600 hover:bg-gray-100 transition"
                >
                  <Globe className="w-4 h-4" />
                  <span className="uppercase text-xs font-medium">{lang}</span>
                </button>
                {showLangMenu && (
                  <div className="absolute right-0 top-full mt-1 bg-white rounded-xl shadow-lg border border-gray-100 py-1 z-30 min-w-[120px]">
                    {[
                      { code: 'ka', label: 'ქართული' },
                      { code: 'en', label: 'English' },
                      { code: 'ru', label: 'Русский' },
                    ].map(l => (
                      <button
                        key={l.code}
                        onClick={() => changeLang(l.code)}
                        className={`w-full text-left px-3 py-1.5 text-sm hover:bg-gray-50 transition ${lang === l.code ? 'text-blue-600 font-medium' : 'text-gray-600'}`}
                      >
                        {l.label}
                      </button>
                    ))}
                  </div>
                )}
              </div>
              {user ? (
                <>
                  <button
                    onClick={() => { setShowFavorites(true); loadFavorites(userToken) }}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm text-gray-600 hover:bg-gray-100 transition"
                  >
                    <Heart className="w-4 h-4" />
                    <span className="hidden sm:inline">{tt('favorites')}</span>
                    {favorites.size > 0 && <span className="text-xs bg-red-500 text-white rounded-full px-1.5 py-0.5">{favorites.size}</span>}
                  </button>
                  <button
                    onClick={handleLogout}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm text-gray-600 hover:bg-gray-100 transition"
                  >
                    <LogOut className="w-4 h-4" />
                    <span className="hidden sm:inline">{tt('logout')}</span>
                  </button>
                </>
              ) : (
                <>
                  <button
                    onClick={() => { setShowAuth(true); setAuthMode('login') }}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm text-gray-600 hover:bg-gray-100 transition"
                  >
                    <User className="w-4 h-4" />
                    <span className="hidden sm:inline">{tt('login')}</span>
                  </button>
                  <button
                    onClick={() => { setShowAuth(true); setAuthMode('register') }}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-sm text-white bg-gradient-to-r from-blue-500 to-indigo-600 hover:shadow-md hover:shadow-blue-500/20 transition"
                  >
                    <UserPlus className="w-4 h-4" />
                    <span className="hidden sm:inline">{tt('register')}</span>
                  </button>
                </>
              )}
            </div>
          </div>

          {/* Search bar */}
          <div className="flex gap-2 flex-col sm:flex-row">
            <div className="relative flex-1 min-w-[200px]" ref={searchRef}>
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 z-10" />
              <input
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={handleSearchKeyDown}
                onFocus={() => suggestions.length > 0 && setShowSuggestions(true)}
                onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
                placeholder={tt('search_placeholder')}
                className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none transition-all duration-200"
                autoComplete="off"
              />
              {showSuggestions && suggestions.length > 0 && (
                <div className="absolute top-full left-0 right-0 mt-1 bg-white rounded-xl border border-gray-200/80 shadow-xl shadow-gray-300/30 z-50 max-h-80 overflow-y-auto">
                  {suggestions.map((s, i) => (
                    <div
                      key={i}
                      onMouseDown={() => handleSuggestionClick(s)}
                      className={`flex items-center gap-3 px-4 py-2.5 cursor-pointer transition ${
                        i === highlightedSuggestion ? 'bg-blue-50' : 'hover:bg-gray-50'
                      }`}
                    >
                      {s.image_url ? (
                        <img src={s.image_url} alt="" className="w-10 h-10 object-contain rounded-lg bg-gray-50 flex-shrink-0" />
                      ) : (
                        <div className="w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center flex-shrink-0">
                          <Music className="w-5 h-5 text-gray-200" />
                        </div>
                      )}
                      <div className="flex-1 min-w-0">
                        <p className="text-sm font-medium text-gray-900 truncate">{s.display_name}</p>
                        <div className="flex items-center gap-2 text-xs text-gray-400">
                          {s.min_price && <span>{s.min_price.toFixed(0)} ₾</span>}
                          {s.store_count > 1 && <span>· {s.store_count} {tt('stores')}</span>}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
            <select
              value={selectedStore}
              onChange={(e) => setSelectedStore(e.target.value)}
              className="px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none text-gray-700 transition-all duration-200 w-full sm:w-auto"
            >
              <option value="">{tt('all_stores')}</option>
              {stores.map((s) => (
                <option key={s.store_name} value={s.store_name}>{s.store_name}</option>
              ))}
            </select>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none text-gray-700 transition-all duration-200 w-full sm:w-auto"
            >
              <option value="price_asc">{tt('sort_price_asc')}</option>
              <option value="price_desc">{tt('sort_price_desc')}</option>
              <option value="name_asc">{tt('sort_name_asc')}</option>
              <option value="diff_desc">{tt('sort_diff_desc')}</option>
              <option value="stores_desc">{tt('sort_stores_desc')}</option>
            </select>
          </div>
        </div>
      </header>

      {/* Stats bar */}
      {stats && (
        <div className="bg-white/60 backdrop-blur-sm border-b border-gray-100">
          <div className="max-w-6xl mx-auto px-4 py-2 flex items-center gap-4 text-sm text-gray-500 overflow-x-auto">
            <span className="flex items-center gap-1.5">
              <Store className="w-4 h-4" />
              {stats.total_stores} {tt('stores')}
            </span>
            <span className="flex items-center gap-1.5">
              <Music className="w-4 h-4" />
              {stats.total_products} {tt('products')}
            </span>
            {stats.last_sync && (
              <span className="text-gray-400">
                განახლდა: {stats.last_sync}
              </span>
            )}
          </div>
        </div>
      )}

      {/* Feedback toast */}
      {feedbackMsg && (
        <div className="fixed top-20 left-1/2 -translate-x-1/2 z-50 bg-green-500 text-white px-6 py-3 rounded-xl shadow-xl shadow-green-500/30 flex items-center gap-2">
          <CheckCircle2 className="w-5 h-5" />
          {feedbackMsg}
        </div>
      )}

      {/* Main content */}
      <main className="max-w-6xl mx-auto px-4 py-6">
        {!query && currentPage === 1 && !loading && (
          <div className="bg-gradient-to-br from-blue-600 via-indigo-600 to-purple-700 rounded-3xl p-5 sm:p-6 md:p-10 mb-8 text-white shadow-xl shadow-indigo-500/20 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-48 h-48 sm:w-64 sm:h-64 bg-white/5 rounded-full -translate-y-24 sm:-translate-y-32 translate-x-24 sm:translate-x-32"></div>
            <div className="absolute bottom-0 left-0 w-32 h-32 sm:w-48 sm:h-48 bg-white/5 rounded-full translate-y-16 sm:translate-y-24 -translate-x-16 sm:-translate-x-24"></div>
            <div className="relative z-10">
            <h2 className="text-xl sm:text-2xl md:text-3xl font-bold mb-2 sm:mb-3">{tt('hero_title')}</h2>
            <p className="text-blue-100 mb-5 sm:mb-6 max-w-2xl text-sm sm:text-base">
              {tt('hero_text')}
            </p>
            {stores.length > 0 && (
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => setSelectedStore('')}
                  className={`px-3 sm:px-4 py-1.5 sm:py-2 rounded-full text-xs sm:text-sm font-medium transition ${
                    selectedStore === '' ? 'bg-white text-blue-700' : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                >
                  {tt('all_stores')}
                </button>
                {stores.map((s) => (
                  <button
                    key={s.store_name}
                    onClick={() => setSelectedStore(s.store_name)}
                    className={`px-3 sm:px-4 py-1.5 sm:py-2 rounded-full text-xs sm:text-sm font-medium transition ${
                      selectedStore === s.store_name ? 'bg-white text-blue-700' : 'bg-white/20 text-white hover:bg-white/30'
                    }`}
                  >
                    {s.store_name}
                  </button>
                ))}
              </div>
            )}
            </div>
          </div>
        )}

        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-[3px] border-blue-500 border-t-transparent rounded-full animate-spin"></div>
          </div>
        ) : products.length === 0 ? (
          <div className="text-center py-20 text-gray-400">
            <div className="w-20 h-20 mx-auto mb-5 rounded-2xl bg-gray-100 flex items-center justify-center">
              <Music className="w-10 h-10 text-gray-300" />
            </div>
            <p className="text-gray-500 font-medium mb-1">{tt('no_products')}</p>
            <p className="text-sm text-gray-400">{tt('no_products_sub')}</p>
          </div>
        ) : (
          <>
            <p className="text-sm text-gray-500 mb-4">{tt('found_products', {count: total})}</p>
            <div className="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-5">
              {products.map((product, idx) => (
                <ProductCard
                  key={product.match_key || idx}
                  product={product}
                  onClick={() => {
                    setSelectedProduct(product)
                    navigate(`/product/${product.match_key}`)
                  }}
                  formatPrice={formatPrice}
                  storeColors={storeColors}
                  isFavorite={favorites.has(product.match_key)}
                  onToggleFavorite={() => toggleFavorite(product.match_key)}
                  lang={lang}
                />
              ))}
            </div>
            {/* Ad space placeholder */}
            {currentPage === 1 && (
              <div className="mt-6 mb-2 rounded-2xl border border-dashed border-gray-200 bg-gray-50/50 py-6 text-center">
                <p className="text-xs text-gray-400 font-medium">{tt('ad_space')}</p>
                <p className="text-[10px] text-gray-300 mt-0.5">დაგვიკავშირდით: mgeladzeilia39@gmail.com</p>
              </div>
            )}
            {total > PAGE_SIZE && (
              <div className="flex items-center justify-center gap-2 mt-8 mb-4">
                <button
                  onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  className="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-300 disabled:opacity-30 disabled:cursor-not-allowed transition-all duration-200"
                >
                  {tt('prev')}
                </button>
                {(() => {
                  const totalPages = Math.ceil(total / PAGE_SIZE)
                  const pages = []
                  const maxButtons = 7
                  let start = Math.max(1, currentPage - 3)
                  let end = Math.min(totalPages, start + maxButtons - 1)
                  if (end - start < maxButtons - 1) start = Math.max(1, end - maxButtons + 1)
                  if (start > 1) pages.push(1, '...')
                  for (let i = start; i <= end; i++) pages.push(i)
                  if (end < totalPages) pages.push('...', totalPages)
                  return pages.map((p, i) =>
                    p === '...' ? (
                      <span key={`dots-${i}`} className="px-2 text-gray-400">...</span>
                    ) : (
                      <button
                        key={p}
                        onClick={() => setCurrentPage(p)}
                        className={`min-w-[40px] px-3 py-2 rounded-lg text-sm font-medium transition ${
                          currentPage === p
                            ? 'bg-blue-500 text-white'
                            : 'border border-gray-200 text-gray-700 hover:bg-gray-50'
                        }`}
                      >
                        {p}
                      </button>
                    )
                  )
                })()}
                <button
                  onClick={() => setCurrentPage(p => Math.min(Math.ceil(total / PAGE_SIZE), p + 1))}
                  disabled={currentPage >= Math.ceil(total / PAGE_SIZE)}
                  className="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-300 disabled:opacity-30 disabled:cursor-not-allowed transition-all duration-200"
                >
                  {tt('next')}
                </button>
              </div>
            )}
          </>
        )}
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200/60 mt-12">
        <div className="max-w-6xl mx-auto px-4 py-8 text-sm text-gray-500">
          <div className="bg-amber-50/80 border border-amber-100 rounded-2xl p-5 mb-6">
            <p className="font-medium text-yellow-800 mb-1">{tt('dev_mode')}</p>
            <p className="mb-2">
              {tt('dev_mode_text')} {tt('info_text')}
            </p>
            <p>
              {tt('report_help')}
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">{tt('collaboration')}</h3>
              <p className="mb-1">{tt('collaboration_text')}</p>
              <a href="mailto:mgeladzeilia39@gmail.com" className="text-blue-600 hover:underline font-medium">mgeladzeilia39@gmail.com</a>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">{tt('creator')}</h3>
              <p className="mb-1">{tt('creator_name')} <span className="text-gray-900 font-medium">Ilia Mgeladze</span>.</p>
              <p>© {new Date().getFullYear()} MusicCompare</p>
            </div>
          </div>
          <div className="mt-6 pt-6 border-t border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-2 text-xs text-gray-400">
              <span>{tt('ad_contact')}</span>
              <a href="mailto:mgeladzeilia39@gmail.com" className="text-blue-500 hover:underline">მეილი</a>
            </div>
          </div>
        </div>
      </footer>

      {/* Product detail modal */}
      {selectedProduct && (
        <ProductModal
          product={selectedProduct}
          onClose={() => { setSelectedProduct(null); navigate('/') }}
          formatPrice={formatPrice}
          storeColors={storeColors}
          onReportWrong={handleFeedback}
          lang={lang}
        />
      )}

      {/* Auth modal */}
      {showAuth && (
        <AuthModal
          mode={authMode}
          onClose={() => setShowAuth(false)}
          onSwitchMode={setAuthMode}
          onLogin={(token, userData) => {
            localStorage.setItem('mc_token', token)
            setUserToken(token)
            setUser(userData)
            setShowAuth(false)
            loadFavorites(token)
          }}
        />
      )}

      {/* Favorites modal */}
      {showFavorites && (
        <FavoritesModal
          favorites={favoritesList}
          onClose={() => setShowFavorites(false)}
          onSelectProduct={(p) => { setSelectedProduct(p); setShowFavorites(false) }}
          onRemoveFavorite={(matchKey) => {
            toggleFavorite(matchKey)
            loadFavorites(userToken)
          }}
          formatPrice={formatPrice}
          storeColors={storeColors}
          ProductCard={ProductCard}
          lang={lang}
        />
      )}

      {/* Admin panel */}
      {showAdmin && (
        <AdminPanel onClose={() => setShowAdmin(false)} />
      )}
    </div>
  )
}

function ProductCard({ product, onClick, formatPrice, storeColors, isFavorite, onToggleFavorite, lang }) {
  const tt = (key, params) => t(key, lang, params)
  const imageSrc = getImageSrc(product.image_url)
  const hasImage = imageSrc !== ''
  const cheapest = product.listings?.find(l => l.store_name === product.cheapest_store)

  return (
    <div
      onClick={onClick}
      className="bg-white rounded-2xl border border-gray-200/70 hover:border-blue-300 hover:shadow-xl hover:shadow-gray-200/50 transition-all duration-300 cursor-pointer overflow-hidden group animate-fade-in"
    >
      {/* Image */}
      <div className="aspect-square bg-gradient-to-b from-gray-50 to-gray-100/50 flex items-center justify-center overflow-hidden relative">
        {hasImage ? (
          <img
            src={imageSrc}
            alt={product.display_name}
            className="w-full h-full object-contain p-3 sm:p-4 group-hover:scale-105 transition duration-300"
            onError={(e) => { e.target.style.display = 'none' }}
          />
        ) : (
          <Music className="w-12 h-12 sm:w-16 sm:h-16 text-gray-200" />
        )}
        {product.price_diff > 0 && (
          <div className="absolute top-2 right-2 bg-green-500 text-white text-[10px] font-bold px-2 py-1 rounded-full shadow-md shadow-green-500/30">
            -{formatPrice(product.price_diff)}
          </div>
        )}
        <button
          onClick={(e) => { e.stopPropagation(); onToggleFavorite() }}
          className={`absolute top-2 left-2 p-1.5 rounded-full transition-all duration-200 ${
            isFavorite
              ? 'bg-red-500 text-white shadow-md shadow-red-500/30'
              : 'bg-white/80 text-gray-400 hover:text-red-500 hover:bg-white opacity-0 group-hover:opacity-100'
          }`}
        >
          <Heart className={`w-4 h-4 ${isFavorite ? 'fill-current' : ''}`} />
        </button>
      </div>

      {/* Content */}
      <div className="p-3 sm:p-4">
        <h3 className="font-medium text-gray-900 text-xs sm:text-sm line-clamp-2 mb-2 min-h-[2.5rem] sm:min-h-[2.5rem]">
          {product.display_name}
        </h3>

        {/* Price + difference */}
        <div className="flex items-baseline gap-2 mb-1">
          <span className="text-base sm:text-xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
            {formatPrice(product.min_price)}
          </span>
          {product.price_diff > 0 && (
            <span className="text-xs text-gray-400 line-through">
              {formatPrice(product.max_price)}
            </span>
          )}
        </div>

        {/* Price difference badge */}
        {product.price_diff > 0 && (
          <div className="flex items-center gap-1 text-xs text-orange-600 font-medium mb-2">
            <TrendingDown className="w-3.5 h-3.5" />
            {tt('price_diff')}: {formatPrice(product.price_diff)}
          </div>
        )}
        {product.price_diff === 0 && (
          <div className="text-xs text-gray-400 mb-2">{tt('one_store')}</div>
        )}

        {/* Store badges */}
        <div className="flex flex-wrap gap-1.5 mb-2">
          {product.listings?.slice(0, 4).map((l, i) => (
            <span
              key={i}
              className={`text-[10px] sm:text-xs text-white px-2 py-0.5 rounded-full ${storeColors[l.store_name] || 'bg-gray-400'}`}
            >
              {l.store_name}
            </span>
          ))}
          {product.listings?.length > 4 && (
            <span className="text-xs text-gray-400 px-1">+{product.listings.length - 4}</span>
          )}
        </div>

        {/* Cheapest store */}
        {cheapest && (
          <div className="flex items-center gap-1 text-xs text-green-600">
            <TrendingDown className="w-3.5 h-3.5" />
            {tt('cheapest_label')}: {cheapest.store_name}
          </div>
        )}
      </div>
    </div>
  )
}

function ProductModal({ product, onClose, formatPrice, storeColors, onReportWrong, lang }) {
  const tt = (key, params) => t(key, lang, params)
  const sortedListings = [...(product.listings || [])].sort((a, b) => {
    const pa = a.price || Infinity
    const pb = b.price || Infinity
    return pa - pb
  })

  const [reportingStore, setReportingStore] = useState(null)
  const [reportNote, setReportNote] = useState('')
  const [reportSent, setReportSent] = useState(false)

  const handleReport = (storeName, listingProductName) => {
    onReportWrong(product.match_key, storeName, listingProductName, reportNote)
    setReportingStore(null)
    setReportNote('')
    setReportSent(true)
    setTimeout(() => setReportSent(false), 3000)
  }

  return (
    <div className="fixed inset-0 bg-black/50 modal-backdrop z-50 flex items-center justify-center p-4" onClick={onClose}>
      <div
        className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Header */}
        <div className="flex items-start justify-between p-5 border-b border-gray-100">
          <div className="flex-1 pr-4">
            <h2 className="text-lg font-bold text-gray-900 mb-1">{product.display_name}</h2>
            <div className="flex items-center gap-3 text-sm text-gray-500">
              {product.store_count > 1 && (
                <span className="flex items-center gap-1">
                  <AlertCircle className="w-3.5 h-3.5" />
                  {product.store_count} {tt('stores')}
                </span>
              )}
              {product.last_updated && (
                <span>{tt('updated')}: {product.last_updated}</span>
              )}
            </div>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-gray-100 rounded-xl transition">
            <X className="w-5 h-5 text-gray-400" />
          </button>
        </div>

        {/* Image */}
        {product.image_url && (
          <div className="flex items-center justify-center bg-gradient-to-b from-gray-50 to-gray-100/50 py-8">
            <img
              src={getImageSrc(product.image_url)}
              alt={product.display_name}
              className="max-h-64 object-contain"
              onError={(e) => { e.target.parentElement.style.display = 'none' }}
            />
          </div>
        )}

        {/* Price summary */}
        <div className="px-5 py-4 bg-gradient-to-r from-blue-50 via-indigo-50 to-purple-50">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs text-gray-500 mb-1">{tt('price_range')}</p>
              <p className="text-2xl font-bold text-gray-900">
                {formatPrice(product.min_price)}
                {product.price_diff > 0 && (
                  <span className="text-base text-gray-400"> — {formatPrice(product.max_price)}</span>
                )}
              </p>
            </div>
            {product.price_diff > 0 && (
              <div className="text-right">
                <p className="text-xs text-gray-500 mb-1">{tt('price_diff')}</p>
                <p className="text-lg font-bold text-green-600">{formatPrice(product.price_diff)}</p>
              </div>
            )}
          </div>
        </div>

        {/* Store listings */}
        <div className="p-5">
          <h3 className="text-sm font-semibold text-gray-700 mb-3">{tt('all_stores_prices')}</h3>
          <div className="space-y-2">
            {sortedListings.map((l, i) => (
              <div
                key={i}
                className={`flex items-center justify-between p-3 rounded-2xl border transition-all duration-200 ${
                  i === 0 ? 'border-green-300/60 bg-green-50/80' : 'border-gray-200/70 hover:border-gray-300 hover:bg-gray-50/50'
                }`}
              >
                <div className="flex items-center gap-3 min-w-0 flex-1">
                  <span className={`w-3 h-3 rounded-full flex-shrink-0 ${storeColors[l.store_name] || 'bg-gray-400'}`}></span>
                  <div className="min-w-0">
                    <p className="font-medium text-gray-900 text-sm">{l.store_name}</p>
                    <p className="text-xs text-gray-400 line-clamp-1">{l.product_name}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2 flex-shrink-0">
                  <span className={`font-bold ${i === 0 ? 'text-green-600' : 'text-gray-700'}`}>
                    {formatPrice(l.price)}
                  </span>
                  {l.link && l.link !== 'N/A' && (
                    <a
                      href={l.link}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="p-2 hover:bg-blue-100 rounded-xl transition text-blue-500"
                    >
                      <ExternalLink className="w-4 h-4" />
                    </a>
                  )}
                  <button
                    onClick={() => setReportingStore(reportingStore === l.store_name ? null : l.store_name)}
                    className="p-2 hover:bg-red-100 rounded-xl transition text-red-400 hover:text-red-500"
                    title={tt('report_wrong')}
                  >
                    <ThumbsDown className="w-4 h-4" />
                  </button>
                </div>
                {reportingStore === l.store_name && (
                  <div className="absolute inset-0 bg-white/95 rounded-2xl flex flex-col items-center justify-center p-4 z-10">
                    <p className="text-sm text-gray-700 mb-2 text-center">
                      {tt('confirm_wrong')} <b>{l.store_name}</b> — "{l.product_name}"?
                    </p>
                    <textarea
                      value={reportNote}
                      onChange={(e) => setReportNote(e.target.value)}
                      placeholder={tt('your_note')}
                      className="w-full max-w-md text-sm p-2 rounded-lg border border-gray-200 mb-2 outline-none focus:border-blue-400"
                      rows={2}
                    />
                    <div className="flex gap-2">
                      <button
                        onClick={() => handleReport(l.store_name, l.product_name)}
                        className="px-4 py-2 rounded-xl bg-red-500 text-white text-sm font-medium hover:bg-red-600 transition"
                      >
                        {tt('confirm_yes')}
                      </button>
                      <button
                        onClick={() => { setReportingStore(null); setReportNote('') }}
                        className="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-600 hover:bg-gray-50 transition"
                      >
                        {tt('cancel')}
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>

          {reportSent && (
            <div className="mt-3 flex items-center gap-2 text-sm text-green-600 bg-green-50 rounded-xl p-3">
              <CheckCircle2 className="w-4 h-4" />
              {tt('reported')}
            </div>
          )}

          {/* Wrong match button - whole group */}
          <button
            onClick={() => onReportWrong(product.match_key, '', '', '')}
            className="mt-4 w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-red-200 text-red-500 hover:bg-red-50 hover:border-red-300 transition-all duration-200 text-sm font-medium"
          >
            <ThumbsDown className="w-4 h-4" />
            {tt('report_product')}
          </button>
        </div>
      </div>
    </div>
  )
}

export default function AppWrapper() {
  return (
    <HashRouter>
      <App />
    </HashRouter>
  )
}
