import SwiftUI

// MARK: - Notification Badge
struct BadgeView: View {
    let count: Int
    var color: Color = .error

    var body: some View {
        if count > 0 {
            Text(count > 99 ? "99+" : "\(count)")
                .font(AppFont.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, count > 9 ? 5 : 0)
                .frame(minWidth: 18, minHeight: 18)
                .background(color)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Tag / Pill
enum TagVariant {
    case discount, new, hot, free, outOfStock, custom(Color, Color)
}

struct TagView: View {
    let text: String
    var variant: TagVariant = .custom(.primaryOrange, .primaryPastel)

    var body: some View {
        Text(text)
            .font(AppFont.labelSM)
            .foregroundStyle(fgColor)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background(bgColor)
            .clipShape(Capsule())
    }

    private var fgColor: Color {
        switch variant {
        case .discount:    return .white
        case .new:         return .white
        case .hot:         return .white
        case .free:        return .success
        case .outOfStock:  return .textSecondary
        case .custom(let fg, _): return fg
        }
    }

    private var bgColor: Color {
        switch variant {
        case .discount:    return .primaryOrange
        case .new:         return .info
        case .hot:         return .error
        case .free:        return .successLight
        case .outOfStock:  return .bgInput
        case .custom(_, let bg): return bg
        }
    }
}

// MARK: - Discount Badge (corner sticker)
struct DiscountBadge: View {
    let percent: Int

    var body: some View {
        Text("-\(percent)%")
            .font(AppFont.labelSM)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background(Color.error)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.xs))
    }
}

// MARK: - Rating Badge
struct RatingBadge: View {
    let rating: Double
    var reviewCount: Int? = nil

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundStyle(Color.ratingYellow)
            Text(String(format: "%.1f", rating))
                .font(AppFont.labelMD)
                .foregroundStyle(Color.textPrimary)
            if let count = reviewCount {
                Text("(\(count))")
                    .font(AppFont.bodySM)
                    .foregroundStyle(Color.textTertiary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        HStack {
            BadgeView(count: 5)
            BadgeView(count: 23)
            BadgeView(count: 120)
        }
        HStack {
            TagView(text: "20% OFF", variant: .discount)
            TagView(text: "NEW", variant: .new)
            TagView(text: "HOT", variant: .hot)
            TagView(text: "FREE Ship", variant: .free)
            TagView(text: "Sold Out", variant: .outOfStock)
        }
        HStack {
            DiscountBadge(percent: 35)
            RatingBadge(rating: 4.5, reviewCount: 120)
        }
    }
    .padding()
    .background(Color.bgPrimary)
}
