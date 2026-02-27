import SwiftUI

// MARK: - Tab Enum
enum AppTab: String, CaseIterable {
    case home     = "Home"
    case explore  = "Explore"
    case cart     = "Cart"
    case wishlist = "Wishlist"
    case profile  = "Profile"

    var icon: String {
        switch self {
        case .home:     return "house"
        case .explore:  return "square.grid.2x2"
        case .cart:     return "cart"
        case .wishlist: return "heart"
        case .profile:  return "person"
        }
    }

    var activeIcon: String {
        switch self {
        case .home:     return "house.fill"
        case .explore:  return "square.grid.2x2.fill"
        case .cart:     return "cart.fill"
        case .wishlist: return "heart.fill"
        case .profile:  return "person.fill"
        }
    }
}

// MARK: - Root ContentView
struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var cartCount: Int = 2

    var body: some View {
        ZStack(alignment: .bottom) {

            // Tab content — switch avoids horizontal swipe conflicts
            // with inner carousels (e.g. banner TabView in HomeView)
            Group {
                switch selectedTab {
                case .home:     HomeView()
                case .explore:  ExploreView()
                case .cart:     CartView()
                case .wishlist: WishlistView()
                case .profile:  ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab, cartCount: cartCount)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    var cartCount: Int = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Spacer()
                TabBarItem(tab: tab, selectedTab: $selectedTab,
                           badge: tab == .cart ? cartCount : 0)
                Spacer()
            }
        }
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.lg)
        .background(
            Color.bgCard
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: -4)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

struct TabBarItem: View {
    let tab: AppTab
    @Binding var selectedTab: AppTab
    var badge: Int = 0

    private var isSelected: Bool { selectedTab == tab }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: isSelected ? tab.activeIcon : tab.icon)
                        .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? Color.primaryOrange : Color.textTertiary)
                        .frame(width: 32, height: 28)
                        .scaleEffect(isSelected ? 1.1 : 1)

                    if badge > 0 {
                        BadgeView(count: badge)
                            .offset(x: 10, y: -6)
                    }
                }

                Text(tab.rawValue)
                    .font(AppFont.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? Color.primaryOrange : Color.textTertiary)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Placeholder Views (replaced screen by screen)

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack { Text("🔍 Explore Screen").font(AppFont.h2) }
                    .padding(.bottom, 90)
            }
            .background(Color.bgPrimary)
        }
    }
}

struct CartView: View {
    var body: some View {
        NavigationStack {
            EmptyStateView(
                icon: "cart",
                title: "Your cart is empty",
                message: "Browse products and add items to your cart",
                actionTitle: "Start Shopping"
            )
            .padding(.bottom, 90)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgPrimary)
        }
    }
}

struct WishlistView: View {
    var body: some View {
        NavigationStack {
            EmptyStateView(
                icon: "heart",
                title: "No wishlist items",
                message: "Save your favourite products here"
            )
            .padding(.bottom, 90)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.bgPrimary)
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack { Text("👤 Profile Screen").font(AppFont.h2) }
                    .padding(.bottom, 90)
            }
            .background(Color.bgPrimary)
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
