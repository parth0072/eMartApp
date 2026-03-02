import Foundation

// MARK: - Notification Type

enum NotificationType: String, Codable {
    case order  = "order"
    case promo  = "promo"
    case system = "system"

    var icon: String {
        switch self {
        case .order:  return "bag.fill"
        case .promo:  return "tag.fill"
        case .system: return "bell.fill"
        }
    }

    var colorHex: String {
        switch self {
        case .order:  return "#3B82F6"
        case .promo:  return "#F97316"
        case .system: return "#8B5CF6"
        }
    }
}

// MARK: - App Notification

struct AppNotification: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var type: NotificationType
    var date: Date
    var isRead: Bool = false

    var timeAgo: String {
        let seconds = Date().timeIntervalSince(date)
        if seconds < 60 { return "Just now" }
        if seconds < 3600 { return "\(Int(seconds / 60))m ago" }
        if seconds < 86400 { return "\(Int(seconds / 3600))h ago" }
        return "\(Int(seconds / 86400))d ago"
    }
}

// MARK: - Sample Notifications

extension AppNotification {
    static let samples: [AppNotification] = [
        AppNotification(title: "Order Shipped! 🚚",
                        body: "Your order #EMAB12CD has been shipped and will arrive by tomorrow.",
                        type: .order, date: Date().addingTimeInterval(-3600)),
        AppNotification(title: "Flash Sale — 50% Off Electronics!",
                        body: "Limited time offer. Shop now and save big on top brands.",
                        type: .promo, date: Date().addingTimeInterval(-7200)),
        AppNotification(title: "Order Delivered ✅",
                        body: "Your order #EMXY89ZW has been delivered. Tap to rate your experience.",
                        type: .order, date: Date().addingTimeInterval(-86400)),
        AppNotification(title: "Use Code SAVE20",
                        body: "Get 20% off on orders above ₹1,000. Valid for next 15 days.",
                        type: .promo, date: Date().addingTimeInterval(-2 * 86400)),
        AppNotification(title: "New Arrivals in Fashion",
                        body: "Check out the latest collection from top brands. New styles added daily.",
                        type: .system, date: Date().addingTimeInterval(-3 * 86400)),
        AppNotification(title: "Your Review Helped Others!",
                        body: "Your review on Sony WH-1000XM5 was marked helpful by 12 people.",
                        type: .system, date: Date().addingTimeInterval(-5 * 86400), isRead: true),
    ]
}
