import SwiftUI

private struct OnboardingPage: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let bgColors: [Color]
}

private let pages: [OnboardingPage] = [
    OnboardingPage(
        icon: "storefront.fill",
        iconColor: .primaryOrange,
        title: "Shop Millions of Products",
        subtitle: "Discover electronics, fashion, home essentials and more — all in one place.",
        bgColors: [Color.primaryPastel, Color.white]
    ),
    OnboardingPage(
        icon: "shippingbox.fill",
        iconColor: Color(hex: "#3B82F6") ?? .blue,
        title: "Fast & Reliable Delivery",
        subtitle: "Get your orders delivered to your doorstep in as little as 24 hours.",
        bgColors: [Color(hex: "#EFF6FF") ?? .blue.opacity(0.1), Color.white]
    ),
    OnboardingPage(
        icon: "tag.fill",
        iconColor: Color(hex: "#10B981") ?? .green,
        title: "Exclusive Deals Every Day",
        subtitle: "Save big with daily flash sales, promo codes, and member-only offers.",
        bgColors: [Color(hex: "#ECFDF5") ?? .green.opacity(0.1), Color.white]
    ),
]

struct OnboardingView: View {
    @AppStorage("emart_hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        VStack(spacing: 0) {
            // Skip
            HStack {
                Spacer()
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        hasSeenOnboarding = true
                    }
                    .font(AppFont.labelLG)
                    .foregroundColor(.textSecondary)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.lg)
                }
            }

            // Pages
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { idx, page in
                    pageView(page)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            // Dots + Buttons
            VStack(spacing: AppSpacing.xl) {
                // Page dots
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { idx in
                        Capsule()
                            .fill(idx == currentPage ? Color.primaryOrange : Color.borderMedium)
                            .frame(width: idx == currentPage ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }

                // Action button
                if currentPage < pages.count - 1 {
                    AppButton(title: "Next", icon: "arrow.right", iconTrailing: true) {
                        withAnimation { currentPage += 1 }
                    }
                    .padding(.horizontal, AppSpacing.xl)
                } else {
                    AppButton(title: "Get Started") {
                        hasSeenOnboarding = true
                    }
                    .padding(.horizontal, AppSpacing.xl)
                }
            }
            .padding(.bottom, AppSpacing.x4l)
        }
        .background(Color.bgPrimary)
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: AppSpacing.x3l) {
            Spacer()

            // Illustration
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: page.bgColors, startPoint: .top, endPoint: .bottom))
                    .frame(width: 220, height: 220)
                Circle()
                    .fill(page.iconColor.opacity(0.12))
                    .frame(width: 160, height: 160)
                Image(systemName: page.icon)
                    .font(.system(size: 72, weight: .medium))
                    .foregroundColor(page.iconColor)
            }

            // Text
            VStack(spacing: AppSpacing.md) {
                Text(page.title)
                    .font(AppFont.h1)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(AppFont.bodyMD)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, AppSpacing.xl)
            }

            Spacer()
        }
    }
}
