import SwiftUI

// MARK: - Color Palette
extension Color {

    // Primary – vibrant orange, e-commerce energy
    static let primaryOrange   = Color(hex: "#F97316")
    static let primaryDark     = Color(hex: "#EA580C")
    static let primaryLight    = Color(hex: "#FDBA74")
    static let primaryPastel   = Color(hex: "#FFF7ED")

    // Neutral
    static let textPrimary     = Color(hex: "#1E293B")
    static let textSecondary   = Color(hex: "#64748B")
    static let textTertiary    = Color(hex: "#94A3B8")
    static let textInverse     = Color.white

    // Surface / Background
    static let bgPrimary       = Color(hex: "#F8FAFC")
    static let bgCard          = Color.white
    static let bgInput         = Color(hex: "#F1F5F9")
    static let bgOverlay       = Color.black.opacity(0.4)

    // Semantic
    static let success         = Color(hex: "#22C55E")
    static let successLight    = Color(hex: "#DCFCE7")
    static let warning         = Color(hex: "#FBBF24")
    static let warningLight    = Color(hex: "#FEF9C3")
    static let error           = Color(hex: "#EF4444")
    static let errorLight      = Color(hex: "#FEE2E2")
    static let info            = Color(hex: "#3B82F6")
    static let infoLight       = Color(hex: "#DBEAFE")

    // Border
    static let borderLight     = Color(hex: "#E2E8F0")
    static let borderMedium    = Color(hex: "#CBD5E1")

    // Rating
    static let ratingYellow    = Color(hex: "#FBBF24")

    // Hex initialiser
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
struct AppFont {
    // Display
    static let display1  = Font.system(size: 32, weight: .bold,   design: .rounded)
    static let display2  = Font.system(size: 28, weight: .bold,   design: .rounded)

    // Heading
    static let h1        = Font.system(size: 24, weight: .bold,   design: .rounded)
    static let h2        = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let h3        = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let h4        = Font.system(size: 16, weight: .semibold, design: .rounded)

    // Body
    static let bodyLG    = Font.system(size: 16, weight: .regular, design: .rounded)
    static let bodyMD    = Font.system(size: 14, weight: .regular, design: .rounded)
    static let bodySM    = Font.system(size: 12, weight: .regular, design: .rounded)

    // Label / Caption
    static let labelLG   = Font.system(size: 14, weight: .medium,  design: .rounded)
    static let labelMD   = Font.system(size: 12, weight: .medium,  design: .rounded)
    static let labelSM   = Font.system(size: 11, weight: .medium,  design: .rounded)
    static let caption   = Font.system(size: 10, weight: .regular, design: .rounded)

    // Price
    static let priceLG   = Font.system(size: 20, weight: .bold,   design: .rounded)
    static let priceMD   = Font.system(size: 16, weight: .bold,   design: .rounded)
    static let priceSM   = Font.system(size: 14, weight: .bold,   design: .rounded)
}

// MARK: - Spacing
struct AppSpacing {
    static let xxs: CGFloat =  2
    static let xs:  CGFloat =  4
    static let sm:  CGFloat =  8
    static let md:  CGFloat = 12
    static let lg:  CGFloat = 16
    static let xl:  CGFloat = 20
    static let xxl: CGFloat = 24
    static let x3l: CGFloat = 32
    static let x4l: CGFloat = 40
    static let x5l: CGFloat = 48
}

// MARK: - Radius
struct AppRadius {
    static let xs:  CGFloat =  4
    static let sm:  CGFloat =  8
    static let md:  CGFloat = 12
    static let lg:  CGFloat = 16
    static let xl:  CGFloat = 20
    static let full: CGFloat = 999
}

// MARK: - Shadow
struct AppShadow {
    static func soft() -> some View {
        return Color.clear
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func cardShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 4)
    }
    func softShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
