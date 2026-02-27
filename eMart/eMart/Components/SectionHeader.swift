import SwiftUI

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var actionTitle: String? = "See All"
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFont.h3)
                    .foregroundStyle(Color.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(AppFont.bodySM)
                        .foregroundStyle(Color.textTertiary)
                }
            }

            Spacer()

            if let actionTitle, let onAction {
                Button(action: onAction) {
                    HStack(spacing: 4) {
                        Text(actionTitle)
                            .font(AppFont.labelMD)
                            .foregroundStyle(Color.primaryOrange)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color.primaryOrange)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(.horizontal, AppSpacing.lg)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    var icon: String? = nil
    var isSelected: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.xs) {
                if let icon {
                    Text(icon)
                        .font(.system(size: 14))
                }
                Text(title)
                    .font(AppFont.labelMD)
                    .foregroundStyle(isSelected ? Color.white : Color.textSecondary)
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(height: 36)
            .background(
                isSelected
                ? AnyShapeStyle(LinearGradient(colors: [.primaryOrange, .primaryDark],
                                               startPoint: .leading, endPoint: .trailing))
                : AnyShapeStyle(Color.bgCard)
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.clear : Color.borderLight, lineWidth: 1)
            )
            .softShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - App Divider
struct AppDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.borderLight)
            .frame(height: 1)
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    let icon: String
    let title: String
    var message: String? = nil
    var actionTitle: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundStyle(Color.textTertiary)

            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppFont.h3)
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)

                if let message {
                    Text(message)
                        .font(AppFont.bodyMD)
                        .foregroundStyle(Color.textTertiary)
                        .multilineTextAlignment(.center)
                }
            }

            if let actionTitle, let onAction {
                AppButton(title: actionTitle, variant: .primary, isFullWidth: false, action: onAction)
            }
        }
        .padding(AppSpacing.x3l)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 24) {
        SectionHeader(title: "Featured Products", subtitle: "Best picks for you", onAction: {})
        SectionHeader(title: "Categories")

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                CategoryChip(title: "All", isSelected: true, onTap: {})
                CategoryChip(title: "Electronics", icon: "📱", onTap: {})
                CategoryChip(title: "Fashion", icon: "👗", onTap: {})
                CategoryChip(title: "Home", icon: "🏠", onTap: {})
            }
            .padding(.horizontal, AppSpacing.lg)
        }

        AppDivider().padding(.horizontal)

        EmptyStateView(
            icon: "cart",
            title: "Your cart is empty",
            message: "Add items to your cart to continue shopping",
            actionTitle: "Start Shopping",
            onAction: {}
        )
    }
    .background(Color.bgPrimary)
}
