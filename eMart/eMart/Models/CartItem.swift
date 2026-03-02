import Foundation

// MARK: - CartItem

struct CartItem: Identifiable, Codable {
    var id: UUID = UUID()
    var product: Product
    var quantity: Int
    var selectedColor: String?
    var selectedSize: String?

    var totalPrice: Double { product.price * Double(quantity) }
}

// MARK: - Payment Method

enum PaymentMethod: String, Codable, CaseIterable, Identifiable {
    case cod = "Cash on Delivery"
    case card = "Credit / Debit Card"
    case upi = "UPI"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .cod:  return "banknote.fill"
        case .card: return "creditcard.fill"
        case .upi:  return "qrcode"
        }
    }

    var description: String {
        switch self {
        case .cod:  return "Pay when your order arrives"
        case .card: return "Visa, Mastercard, Amex"
        case .upi:  return "GPay, PhonePe, Paytm"
        }
    }
}

// MARK: - Delivery Option

enum DeliveryOption: String, Codable, CaseIterable, Identifiable {
    case standard = "Standard Delivery"
    case express = "Express Delivery"
    case overnight = "Overnight Delivery"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .standard:  return "shippingbox.fill"
        case .express:   return "bolt.fill"
        case .overnight: return "moon.stars.fill"
        }
    }

    var estimatedDays: String {
        switch self {
        case .standard:  return "3–5 business days"
        case .express:   return "1–2 business days"
        case .overnight: return "Next day delivery"
        }
    }

    var charge: Double {
        switch self {
        case .standard:  return 0
        case .express:   return 99
        case .overnight: return 199
        }
    }

    var isFree: Bool { charge == 0 }
}
