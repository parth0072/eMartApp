import Foundation

// MARK: - Order Status

enum OrderStatus: String, Codable, CaseIterable {
    case placed        = "Order Placed"
    case confirmed     = "Confirmed"
    case shipped       = "Shipped"
    case outForDelivery = "Out for Delivery"
    case delivered     = "Delivered"
    case cancelled     = "Cancelled"

    var icon: String {
        switch self {
        case .placed:         return "checkmark.circle.fill"
        case .confirmed:      return "bag.fill"
        case .shipped:        return "shippingbox.fill"
        case .outForDelivery: return "bicycle"
        case .delivered:      return "house.fill"
        case .cancelled:      return "xmark.circle.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .placed:         return "#3B82F6"
        case .confirmed:      return "#8B5CF6"
        case .shipped:        return "#F59E0B"
        case .outForDelivery: return "#F97316"
        case .delivered:      return "#10B981"
        case .cancelled:      return "#EF4444"
        }
    }

    var stepIndex: Int {
        switch self {
        case .placed:         return 0
        case .confirmed:      return 1
        case .shipped:        return 2
        case .outForDelivery: return 3
        case .delivered:      return 4
        case .cancelled:      return -1
        }
    }

    var isActive: Bool { self != .cancelled }
}

// MARK: - Tracking Step

struct TrackingStep: Identifiable {
    var id: Int
    var title: String
    var subtitle: String
    var status: OrderStatus
    var isCompleted: Bool
    var isCurrent: Bool
}

// MARK: - Order Item

struct OrderItem: Identifiable, Codable {
    var id: UUID = UUID()
    var product: Product
    var quantity: Int
    var price: Double
    var selectedColor: String?
    var selectedSize: String?

    var totalPrice: Double { price * Double(quantity) }
}

// MARK: - Order

struct Order: Identifiable, Codable {
    var id: UUID = UUID()
    var orderNumber: String
    var userId: UUID
    var items: [OrderItem]
    var deliveryAddress: Address
    var paymentMethod: PaymentMethod
    var deliveryOption: DeliveryOption
    var subtotal: Double
    var discount: Double
    var tax: Double
    var deliveryCharge: Double
    var total: Double
    var status: OrderStatus
    var placedDate: Date
    var estimatedDelivery: Date
    var promoCode: String?

    var formattedDate: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: placedDate)
    }

    var estimatedDeliveryString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: estimatedDelivery)
    }

    var trackingSteps: [TrackingStep] {
        let steps: [(String, String, OrderStatus)] = [
            ("Order Placed", "We received your order", .placed),
            ("Confirmed", "Seller confirmed your order", .confirmed),
            ("Shipped", "Your order is on the way", .shipped),
            ("Out for Delivery", "Arriving today", .outForDelivery),
            ("Delivered", "Order delivered successfully", .delivered),
        ]
        return steps.enumerated().map { idx, step in
            TrackingStep(
                id: idx,
                title: step.0,
                subtitle: step.1,
                status: step.2,
                isCompleted: status.stepIndex > idx,
                isCurrent: status.stepIndex == idx
            )
        }
    }

    static func generateOrderNumber() -> String {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let random = String((0..<8).map { _ in chars.randomElement()! })
        return "EM\(random)"
    }
}
