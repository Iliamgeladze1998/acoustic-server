import { useState, useEffect, useCallback, useRef } from 'react'
import { Search, Music, Store, TrendingDown, AlertCircle, X, ExternalLink, CheckCircle2, ThumbsDown } from 'lucide-react'

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
  const PAGE_SIZE = 24

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

  useEffect(() => {
    fetchStores()
    fetchStats()
  }, [fetchStores, fetchStats])

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

  const handleFeedback = async (matchKey, tabName) => {
    try {
      const res = await fetch(`${API_BASE}/api/feedback`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ match_key: matchKey, tab_name: tabName }),
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
            className="flex items-center gap-3 mb-3 cursor-pointer group"
            onClick={goHome}
          >
            <div className="w-11 h-11 bg-gradient-to-br from-blue-500 via-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center shadow-lg shadow-blue-500/20 group-hover:scale-105 group-hover:shadow-blue-500/30 transition-all duration-300">
              <LogoIcon className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900 group-hover:text-blue-600 transition tracking-tight">MusicCompare</h1>
              <p className="text-xs text-gray-500 tracking-wide">მუსიკალური ინსტრუმენტების საუკეთესო ფასები საქართველოს მაღაზიებში</p>
            </div>
          </div>

          {/* Search bar */}
          <div className="flex gap-2 flex-wrap">
            <div className="relative flex-1 min-w-[200px]" ref={searchRef}>
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 z-10" />
              <input
                type="text"
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                onKeyDown={handleSearchKeyDown}
                onFocus={() => suggestions.length > 0 && setShowSuggestions(true)}
                onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
                placeholder="მოძებნე პროდუქტი..."
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
                          {s.store_count > 1 && <span>· {s.store_count} მაღაზია</span>}
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
              className="px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none text-gray-700 transition-all duration-200"
            >
              <option value="">ყველა მაღაზია</option>
              {stores.map((s) => (
                <option key={s.store_name} value={s.store_name}>{s.store_name}</option>
              ))}
            </select>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:bg-white focus:border-blue-500 focus:ring-2 focus:ring-blue-100 outline-none text-gray-700 transition-all duration-200"
            >
              <option value="price_asc">ფასი: დაბალი → მაღალი</option>
              <option value="price_desc">ფასი: მაღალი → დაბალი</option>
              <option value="name_asc">სახელი: A → Z</option>
              <option value="diff_desc">ფასთა სხვაობა</option>
              <option value="stores_desc">მაღაზიების რაოდენობა</option>
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
              {stats.total_stores} მაღაზია
            </span>
            <span className="flex items-center gap-1.5">
              <Music className="w-4 h-4" />
              {stats.total_products} პროდუქტი
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
          <div className="bg-gradient-to-br from-blue-600 via-indigo-600 to-purple-700 rounded-3xl p-6 md:p-10 mb-8 text-white shadow-xl shadow-indigo-500/20 relative overflow-hidden">
            <div className="absolute top-0 right-0 w-64 h-64 bg-white/5 rounded-full -translate-y-32 translate-x-32"></div>
            <div className="absolute bottom-0 left-0 w-48 h-48 bg-white/5 rounded-full translate-y-24 -translate-x-24"></div>
            <h2 className="text-2xl md:text-3xl font-bold mb-3">იპოვე საუკეთესო ფასი მუსიკალურ ინსტრუმენტებზე</h2>
            <p className="text-blue-100 mb-6 max-w-2xl">
              MusicCompare ადარებს საქართველოს მუსიკალური ინსტრუმენტების მაღაზიებს და გაჩვენებს საუკეთესო შეთავაზებებს ერთ ადგილას.
            </p>
            {stores.length > 0 && (
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => setSelectedStore('')}
                  className={`px-4 py-2 rounded-full text-sm font-medium transition ${
                    selectedStore === '' ? 'bg-white text-blue-700' : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                >
                  ყველა
                </button>
                {stores.map((s) => (
                  <button
                    key={s.store_name}
                    onClick={() => setSelectedStore(s.store_name)}
                    className={`px-4 py-2 rounded-full text-sm font-medium transition ${
                      selectedStore === s.store_name ? 'bg-white text-blue-700' : 'bg-white/20 text-white hover:bg-white/30'
                    }`}
                  >
                    {s.store_name}
                  </button>
                ))}
              </div>
            )}
          </div>
        )}

        {loading ? (
          <div className="flex items-center justify-center py-20">
            <div className="w-8 h-8 border-[3px] border-blue-500 border-t-transparent rounded-full animate-spin"></div>
          </div>
        ) : products.length === 0 ? (
          <div className="text-center py-20 text-gray-400">
            <Music className="w-16 h-16 mx-auto mb-4 opacity-30" />
            <p>პროდუქტი ვერ მოიძებნა</p>
          </div>
        ) : (
          <>
            <p className="text-sm text-gray-500 mb-4">ნაპოვნია {total} პროდუქტი</p>
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
              {products.map((product, idx) => (
                <ProductCard
                  key={product.match_key || idx}
                  product={product}
                  onClick={() => setSelectedProduct(product)}
                  formatPrice={formatPrice}
                  storeColors={storeColors}
                />
              ))}
            </div>
            {total > PAGE_SIZE && (
              <div className="flex items-center justify-center gap-2 mt-8 mb-4">
                <button
                  onClick={() => setCurrentPage(p => Math.max(1, p - 1))}
                  disabled={currentPage === 1}
                  className="px-4 py-2 rounded-xl border border-gray-200 text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-300 disabled:opacity-30 disabled:cursor-not-allowed transition-all duration-200"
                >
                  წინა
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
                  შემდეგი
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
            <p className="font-medium text-yellow-800 mb-1">საიტი აქტიური განვითარების რეჟიმშია</p>
            <p className="mb-2">
              საიტი აწყობის და ტესტირების ეტაპზეა. შესაძლოა ზოგიერთი პროდუქტი არასწორად დაჯგუფდეს ან ფასი არაზუსტად გამოჩნდეს.
              წარმოდგენილი ინფორმაცია მხოლოდ საინფორმაციო და შედარებისათვის განკუთვნილია.
            </p>
            <p>
              თუ რაიმე პროდუქტი არ ემთხვევა, გთხოვთ მონიშნოთ — ეს მნიშვნელოვნად დაგვეხმარება საიტის გაუმჯობესებაში.
            </p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">თანამშრომლობა</h3>
              <p className="mb-1">მაღაზიებს, რომელთაც უნდათ API-ით ინფორმაციის პირდაპირ მოწოდება, შეუძლიათ დაგვიკავშირდნენ.</p>
              <a href="mailto:mgeladzeilia39@gmail.com" className="text-blue-600 hover:underline font-medium">mgeladzeilia39@gmail.com</a>
            </div>
            <div>
              <h3 className="font-semibold text-gray-900 mb-2">შემქმნელი</h3>
              <p className="mb-1">საიტის შემქმნელია <span className="text-gray-900 font-medium">Ilia Mgeladze</span>.</p>
              <p>© {new Date().getFullYear()} MusicCompare</p>
            </div>
          </div>
        </div>
      </footer>

      {/* Product detail modal */}
      {selectedProduct && (
        <ProductModal
          product={selectedProduct}
          onClose={() => setSelectedProduct(null)}
          formatPrice={formatPrice}
          storeColors={storeColors}
          onReportWrong={() => handleFeedback(selectedProduct.match_key, '')}
        />
      )}
    </div>
  )
}

function ProductCard({ product, onClick, formatPrice, storeColors }) {
  const imageSrc = getImageSrc(product.image_url)
  const hasImage = imageSrc !== ''
  const cheapest = product.listings?.find(l => l.store_name === product.cheapest_store)

  return (
    <div
      onClick={onClick}
      className="bg-white rounded-2xl border border-gray-200/70 hover:border-blue-300 hover:shadow-xl hover:shadow-gray-200/50 transition-all duration-300 cursor-pointer overflow-hidden group animate-fade-in"
    >
      {/* Image */}
      <div className="aspect-square bg-gradient-to-b from-gray-50 to-gray-100/50 flex items-center justify-center overflow-hidden">
        {hasImage ? (
          <img
            src={imageSrc}
            alt={product.display_name}
            className="w-full h-full object-contain p-4 group-hover:scale-105 transition"
            onError={(e) => { e.target.style.display = 'none' }}
          />
        ) : (
          <Music className="w-16 h-16 text-gray-200" />
        )}
      </div>

      {/* Content */}
      <div className="p-4">
        <h3 className="font-medium text-gray-900 text-sm line-clamp-2 mb-2 min-h-[2.5rem]">
          {product.display_name}
        </h3>

        {/* Price + difference */}
        <div className="flex items-baseline gap-2 mb-1">
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent">
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
            სხვაობა: {formatPrice(product.price_diff)}
          </div>
        )}
        {product.price_diff === 0 && (
          <div className="text-xs text-gray-400 mb-2">ერთ მაღაზიაშია</div>
        )}

        {/* Store badges */}
        <div className="flex flex-wrap gap-1.5 mb-2">
          {product.listings?.slice(0, 4).map((l, i) => (
            <span
              key={i}
              className={`text-xs text-white px-2 py-0.5 rounded-full ${storeColors[l.store_name] || 'bg-gray-400'}`}
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
            ყველაზე იაფი: {cheapest.store_name}
          </div>
        )}
      </div>
    </div>
  )
}

function ProductModal({ product, onClose, formatPrice, storeColors, onReportWrong }) {
  const sortedListings = [...(product.listings || [])].sort((a, b) => {
    const pa = a.price || Infinity
    const pb = b.price || Infinity
    return pa - pb
  })

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
                  {product.store_count} მაღაზია
                </span>
              )}
              {product.last_updated && (
                <span>განახლდა: {product.last_updated}</span>
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
              <p className="text-xs text-gray-500 mb-1">ფასის დიაპაზონი</p>
              <p className="text-2xl font-bold text-gray-900">
                {formatPrice(product.min_price)}
                {product.price_diff > 0 && (
                  <span className="text-base text-gray-400"> — {formatPrice(product.max_price)}</span>
                )}
              </p>
            </div>
            {product.price_diff > 0 && (
              <div className="text-right">
                <p className="text-xs text-gray-500 mb-1">სხვაობა</p>
                <p className="text-lg font-bold text-green-600">{formatPrice(product.price_diff)}</p>
              </div>
            )}
          </div>
        </div>

        {/* Store listings */}
        <div className="p-5">
          <h3 className="text-sm font-semibold text-gray-700 mb-3">მაღაზიების ფასები</h3>
          <div className="space-y-2">
            {sortedListings.map((l, i) => (
              <div
                key={i}
                className={`flex items-center justify-between p-3 rounded-xl border ${
                  i === 0 ? 'border-green-300 bg-green-50' : 'border-gray-200'
                }`}
              >
                <div className="flex items-center gap-3">
                  <span className={`w-3 h-3 rounded-full ${storeColors[l.store_name] || 'bg-gray-400'}`}></span>
                  <div>
                    <p className="font-medium text-gray-900 text-sm">{l.store_name}</p>
                    <p className="text-xs text-gray-400 line-clamp-1">{l.product_name}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
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
                </div>
              </div>
            ))}
          </div>

          {/* Wrong match button */}
          <button
            onClick={onReportWrong}
            className="mt-4 w-full flex items-center justify-center gap-2 py-2.5 rounded-xl border border-red-200 text-red-500 hover:bg-red-50 hover:border-red-300 transition-all duration-200 text-sm font-medium"
          >
            <ThumbsDown className="w-4 h-4" />
            პროდუქტები არ ემთხვევა ერთმანეთს
          </button>
        </div>
      </div>
    </div>
  )
}

export default App
