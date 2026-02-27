import SwiftUI

// MARK: - Button Style Enum
enum AppButtonVariant {
    case primary, secondary, outline, ghost, danger
}

enum AppButtonSize {
    case sm, md, lg

    var height: CGFloat {
        switch self { case .sm: return 36; case .md: return 48; case .lg: return 56 }
    }
    var font: Font {
        switch self { case .sm: return AppFont.labelMD; case .md: return AppFont.labelLG; case .lg: return AppFont.h4 }
    }
    var hPad: CGFloat {
        switch self { case .sm: return 12; case .md: return 20; case .lg: return 24 }
    }
}

// MARK: - Primary Button
struct AppButton: View {
    let title: String
    var icon: String?
    var iconTrailing: Bool = false
    var variant: AppButtonVariant = .primary
    var size: AppButtonSize = .md
    var isFullWidth: Bool = true
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: { if !isDisabled && !isLoading { action() } }) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: fgColor))
                        .scaleEffect(0.8)
                } else {
                    if let icon, !iconTrailing {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                    Text(title)
                        .font(size.font)
                        .lineLimit(1)
                    if let icon, iconTrailing {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            .foregroundStyle(fgColor)
            .padding(.horizontal, size.hPad)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: size.height)
            .background(bgView)
            .overlay(borderView)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .opacity(isDisabled ? 0.5 : 1)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isDisabled || isLoading)
    }

    @ViewBuilder
    private var bgView: some View {
        switch variant {
        case .primary:
            LinearGradient(colors: [.primaryOrange, .primaryDark],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        case .secondary:
            Color.primaryPastel
        case .outline, .ghost:
            Color.clear
        case .danger:
            Color.error
        }
    }

    @ViewBuilder
    private var borderView: some View {
        switch variant {
        case .outline:
            RoundedRectangle(cornerRadius: AppRadius.md)
                .stroke(Color.primaryOrange, lineWidth: 1.5)
        default:
            EmptyView()
        }
    }

    private var fgColor: Color {
        switch variant {
        case .primary, .danger: return .white
        case .secondary, .outline, .ghost: return .primaryOrange
        }
    }
}

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    var size: CGFloat = 44
    var iconSize: CGFloat = 20
    var color: Color = .textPrimary
    var bgColor: Color = .bgInput
    var badge: Int = 0
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .medium))
                    .foregroundStyle(color)
                    .frame(width: size, height: size)
                    .background(bgColor)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

                if badge > 0 {
                    BadgeView(count: badge)
                        .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Floating Action Button
struct FAButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(colors: [.primaryOrange, .primaryDark],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(Circle())
                .cardShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Scale Press Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        AppButton(title: "Add to Cart", icon: "cart.fill", variant: .primary) {}
        AppButton(title: "Save to Wishlist", icon: "heart", variant: .secondary) {}
        AppButton(title: "Learn More", icon: "arrow.right", iconTrailing: true, variant: .outline) {}
        AppButton(title: "Loading...", variant: .primary, isLoading: true) {}
        HStack {
            IconButton(icon: "bell.fill", badge: 3) {}
            IconButton(icon: "heart", color: .error, bgColor: .errorLight) {}
            FAButton(icon: "plus") {}
        }
    }
    .padding()
    .background(Color.bgPrimary)
}
