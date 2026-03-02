import Foundation
import Combine

class StoreViewModel: ObservableObject {

    // MARK: - Published
    @Published var products: [Product] = Product.samples
    @Published var categories: [ProductCategory] = ProductCategory.samples
    @Published var wishlistIds: Set<UUID> = []
    @Published var reviews: [Review] = []
    @Published var recentSearches: [String] = []
    @Published var notifications: [AppNotification] = AppNotification.samples

    // MARK: - UserDefaults Keys
    private let wishlistKey   = "emart_wishlist"
    private let reviewsKey    = "emart_reviews"
    private let searchesKey   = "emart_searches"
    private let notifKey      = "emart_notifications"

    // MARK: - Init
    init() {
        loadWishlist()
        loadReviews()
        loadSearches()
        loadNotifications()
    }

    // MARK: - Wishlist

    func isWishlisted(_ id: UUID) -> Bool { wishlistIds.contains(id) }

    func toggleWishlist(_ id: UUID) {
        if wishlistIds.contains(id) {
            wishlistIds.remove(id)
        } else {
            wishlistIds.insert(id)
        }
        saveWishlist()
    }

    var wishlistedProducts: [Product] {
        products.filter { wishlistIds.contains($0.id) }
    }

    // MARK: - Search

    func search(query: String) -> [Product] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        let q = query.lowercased()
        return products.filter {
            $0.name.lowercased().contains(q) ||
            $0.brand.lowercased().contains(q) ||
            $0.category.lowercased().contains(q) ||
            $0.subcategory.lowercased().contains(q) ||
            $0.tags.contains(where: { $0.lowercased().contains(q) })
        }
    }

    func addRecentSearch(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        recentSearches.removeAll { $0.lowercased() == trimmed.lowercased() }
        recentSearches.insert(trimmed, at: 0)
        if recentSearches.count > 10 { recentSearches = Array(recentSearches.prefix(10)) }
        saveSearches()
    }

    func clearRecentSearches() {
        recentSearches = []
        saveSearches()
    }

    // MARK: - Product Filtering

    func products(for category: String, subcategory: String? = nil) -> [Product] {
        products.filter {
            $0.category == category &&
            (subcategory == nil || $0.subcategory == subcategory)
        }
    }

    var featuredProducts: [Product] { products.filter { $0.isFeatured } }
    var bestSellers: [Product]      { products.filter { $0.isBestSeller } }
    var newArrivals: [Product]      { products.filter { $0.isNew } }

    func relatedProducts(for product: Product) -> [Product] {
        products.filter { $0.category == product.category && $0.id != product.id }.prefix(8).map { $0 }
    }

    func category(named name: String) -> ProductCategory? {
        categories.first { $0.name == name }
    }

    // MARK: - Reviews

    func reviews(for productId: UUID) -> [Review] {
        let stored = reviews.filter { $0.productId == productId }
        if stored.isEmpty { return Review.samples(for: productId) }
        return stored
    }

    func addReview(_ review: Review) {
        reviews.append(review)
        saveReviews()
        // Update product rating (simple average)
        let productReviews = reviews.filter { $0.productId == review.productId }
        let avg = Double(productReviews.map { $0.rating }.reduce(0, +)) / Double(productReviews.count)
        if let idx = products.firstIndex(where: { $0.id == review.productId }) {
            products[idx].rating = (avg * 10).rounded() / 10
            products[idx].reviewCount = productReviews.count
        }
    }

    // MARK: - Notifications

    var unreadCount: Int { notifications.filter { !$0.isRead }.count }

    func markAllRead() {
        notifications = notifications.map { var n = $0; n.isRead = true; return n }
        saveNotifications()
    }

    func markRead(_ id: UUID) {
        if let idx = notifications.firstIndex(where: { $0.id == id }) {
            notifications[idx].isRead = true
            saveNotifications()
        }
    }

    // MARK: - Persistence

    private func saveWishlist() {
        if let data = try? JSONEncoder().encode(Array(wishlistIds)) {
            UserDefaults.standard.set(data, forKey: wishlistKey)
        }
    }

    private func loadWishlist() {
        guard let data = UserDefaults.standard.data(forKey: wishlistKey),
              let ids = try? JSONDecoder().decode([UUID].self, from: data) else { return }
        wishlistIds = Set(ids)
    }

    private func saveReviews() {
        if let data = try? JSONEncoder().encode(reviews) {
            UserDefaults.standard.set(data, forKey: reviewsKey)
        }
    }

    private func loadReviews() {
        guard let data = UserDefaults.standard.data(forKey: reviewsKey),
              let r = try? JSONDecoder().decode([Review].self, from: data) else { return }
        reviews = r
    }

    private func saveSearches() {
        UserDefaults.standard.set(recentSearches, forKey: searchesKey)
    }

    private func loadSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: searchesKey) ?? []
    }

    private func saveNotifications() {
        if let data = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(data, forKey: notifKey)
        }
    }

    private func loadNotifications() {
        guard let data = UserDefaults.standard.data(forKey: notifKey),
              let n = try? JSONDecoder().decode([AppNotification].self, from: data) else { return }
        if !n.isEmpty { notifications = n }
    }
}
