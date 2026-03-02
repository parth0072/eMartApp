import Foundation
import Combine

class CartViewModel: ObservableObject {

    // MARK: - Published
    @Published var items: [CartItem] = []
    @Published var appliedPromo: PromoCode?

    private let cartKey  = "emart_cart"
    private let promoKey = "emart_promo"

    // MARK: - Init
    init() {
        loadCart()
        loadPromo()
    }

    // MARK: - Cart Operations

    func add(product: Product, quantity: Int = 1, color: String? = nil, size: String? = nil) {
        if let idx = items.firstIndex(where: {
            $0.product.id == product.id &&
            $0.selectedColor == color &&
            $0.selectedSize == size
        }) {
            items[idx].quantity = min(items[idx].quantity + quantity, 10)
        } else {
            items.append(CartItem(product: product, quantity: quantity,
                                  selectedColor: color, selectedSize: size))
        }
        saveCart()
    }

    func remove(id: UUID) {
        items.removeAll { $0.id == id }
        saveCart()
    }

    func updateQuantity(id: UUID, quantity: Int) {
        guard quantity > 0 else { remove(id: id); return }
        if let idx = items.firstIndex(where: { $0.id == id }) {
            items[idx].quantity = min(quantity, 10)
            saveCart()
        }
    }

    func clearCart() {
        items = []
        appliedPromo = nil
        saveCart()
        UserDefaults.standard.removeObject(forKey: promoKey)
    }

    func contains(_ productId: UUID) -> Bool {
        items.contains { $0.product.id == productId }
    }

    // MARK: - Promo Codes

    @discardableResult
    func applyPromoCode(_ code: String) -> Bool {
        guard let promo = PromoCode.samples.first(where: {
            $0.code.uppercased() == code.uppercased() && $0.isValid
        }) else { return false }
        guard subtotal >= promo.minOrder else { return false }
        appliedPromo = promo
        savePromo()
        return true
    }

    func clearPromo() {
        appliedPromo = nil
        UserDefaults.standard.removeObject(forKey: promoKey)
    }

    // MARK: - Pricing

    var itemCount: Int { items.reduce(0) { $0 + $1.quantity } }

    var subtotal: Double { items.reduce(0) { $0 + $1.totalPrice } }

    var discount: Double {
        guard let promo = appliedPromo else { return 0 }
        let raw = subtotal * Double(promo.discountPercent) / 100
        return min(raw, promo.maxDiscount)
    }

    var discountedSubtotal: Double { max(subtotal - discount, 0) }

    var tax: Double { (discountedSubtotal * 0.05).rounded() }

    func total(deliveryCharge: Double) -> Double {
        discountedSubtotal + tax + deliveryCharge
    }

    // MARK: - Persistence

    private func saveCart() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: cartKey)
        }
    }

    private func loadCart() {
        guard let data = UserDefaults.standard.data(forKey: cartKey),
              let decoded = try? JSONDecoder().decode([CartItem].self, from: data) else { return }
        items = decoded
    }

    private func savePromo() {
        if let data = try? JSONEncoder().encode(appliedPromo) {
            UserDefaults.standard.set(data, forKey: promoKey)
        }
    }

    private func loadPromo() {
        guard let data = UserDefaults.standard.data(forKey: promoKey),
              let promo = try? JSONDecoder().decode(PromoCode.self, from: data) else { return }
        if promo.isValid { appliedPromo = promo }
    }
}
