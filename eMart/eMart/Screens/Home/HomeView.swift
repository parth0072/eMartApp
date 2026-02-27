import SwiftUI

// MARK: - Local Data Models

struct PromoBanner: Identifiable {
    let id = UUID()
    let tag: String
    let headline: String
    let offerTitle: String
    let offerSubtitle: String
    let bgColors: [Color]
    let symbolName: String
}

struct HomeCategory: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct PreviousOrder: Identifiable {
    let id = UUID()
    let status: String
    let statusColor: Color
    let date: String
    let itemIcons: [String]
    let extraCount: Int
    let promoLabel: String?
}

// MARK: - HomeView

struct HomeView: View {

    @State private var searchText  = ""
    @State private var bannerPage  = 0

    // MARK: Sample Data
    let banners: [PromoBanner] = [
        PromoBanner(tag: "Weekend Deal",
                    headline: "Happy Weekend",
                    offerTitle: "25% OFF",
                    offerSubtitle: "• For All Items",
                    bgColors: [Color(hex: "#E8F5E9"), Color(hex: "#F1F8E9")],
                    symbolName: "bag.fill"),
        PromoBanner(tag: "Flash Sale",
                    headline: "Today Only",
                    offerTitle: "40% OFF",
                    offerSubtitle: "• Electronics",
                    bgColors: [Color(hex: "#E3F2FD"), Color(hex: "#E8EAF6")],
                    symbolName: "bolt.circle.fill"),
        PromoBanner(tag: "New Arrival",
                    headline: "Fresh Picks",
                    offerTitle: "FREE Ship",
                    offerSubtitle: "• Orders Over $30",
                    bgColors: [Color(hex: "#FFF3E0"), Color(hex: "#FBE9E7")],
                    symbolName: "star.circle.fill"),
    ]

    let categories: [HomeCategory] = [
        HomeCategory(name: "Groceries",  icon: "leaf.fill",     color: Color(hex: "#4DB6AC")),
        HomeCategory(name: "Appliances", icon: "washer.fill",   color: Color(hex: "#5C9BD6")),
        HomeCategory(name: "Fashion",    icon: "tshirt.fill",   color: Color(hex: "#BA68C8")),
        HomeCategory(name: "Furniture",  icon: "sofa.fill",     color: Color(hex: "#9575CD")),
        HomeCategory(name: "Beauty",     icon: "sparkles",      color: Color(hex: "#F06292")),
        HomeCategory(name: "Sports",     icon: "figure.run",    color: Color(hex: "#FF8A65")),
    ]

    let orders: [PreviousOrder] = [
        PreviousOrder(status: "Delivered",
                      statusColor: .success,
                      date: "On Wed, 27 Jul 2022",
                      itemIcons: ["leaf.circle.fill", "fork.knife.circle.fill", "cup.and.saucer.fill"],
                      extraCount: 5,
                      promoLabel: "Get Flat 10% OFF"),
    ]

    // MARK: Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                topBarSection
                locationSection
                searchSection
                bannerSection
                    .padding(.top, 2)
                categoriesSection
                previousOrderSection
            }
            .padding(.bottom, 100)
        }
        .background(Color.bgPrimary)
    }

    // MARK: — Top Bar
    private var topBarSection: some View {
        HStack(spacing: AppSpacing.md) {

            // Logo
            HStack(spacing: 1) {
                Text("e")
                    .foregroundStyle(Color.primaryOrange)
                Text("Mart")
                    .foregroundStyle(Color.textPrimary)
            }
            .font(.system(size: 26, weight: .black, design: .rounded))

            Spacer()

            // Language selector
            HStack(spacing: 4) {
                Text("Eng")
                    .font(AppFont.labelMD)
                    .foregroundStyle(Color.textSecondary)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Color.bgInput)
            .clipShape(Capsule())

            // Notification bell
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primaryOrange)
                    .frame(width: 42, height: 42)
                    .background(Color.primaryPastel)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
                BadgeView(count: 2)
                    .offset(x: 6, y: -6)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.bgCard)
    }

    // MARK: — Location
    private var locationSection: some View {
        Button(action: {}) {
            HStack(spacing: AppSpacing.md) {

                // Teal pin circle
                ZStack {
                    Circle()
                        .fill(Color(hex: "#E0F2F1"))
                        .frame(width: 46, height: 46)
                    Image(systemName: "location.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#4DB6AC"))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Bengaluru")
                        .font(AppFont.h4)
                        .foregroundStyle(Color.textPrimary)
                    Text("BTM Layout, 500628")
                        .font(AppFont.bodySM)
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(Color.bgCard)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    // MARK: — Search
    private var searchSection: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17))
                .foregroundStyle(Color.textTertiary)

            TextField("Search Anything...", text: $searchText)
                .font(AppFont.bodyMD)
                .foregroundStyle(Color.textPrimary)

            Spacer(minLength: 0)

            Rectangle()
                .fill(Color.borderLight)
                .frame(width: 1, height: 22)
                .padding(.horizontal, 2)

            Button(action: {}) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.primaryOrange)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 50)
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .stroke(Color.borderLight, lineWidth: 1)
        )
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(Color.bgCard)
    }

    // MARK: — Banner Carousel
    private var bannerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            TabView(selection: $bannerPage) {
                ForEach(Array(banners.enumerated()), id: \.element.id) { i, banner in
                    PromoBannerCard(banner: banner)
                        .padding(.horizontal, AppSpacing.lg)
                        .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 155)

            // Page dots
            HStack(spacing: 5) {
                ForEach(0..<banners.count, id: \.self) { i in
                    Capsule()
                        .fill(i == bannerPage ? Color.primaryOrange : Color.borderMedium)
                        .frame(width: i == bannerPage ? 18 : 6, height: 6)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: bannerPage)
                }
            }
        }
        .padding(.vertical, AppSpacing.lg)
        .background(Color.bgCard)
    }

    // MARK: — Categories
    private var categoriesSection: some View {
        VStack(spacing: AppSpacing.md) {
            SectionHeader(title: "Categories", onAction: {})
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.xl) {
                    ForEach(categories) { cat in
                        HomeCategoryTile(category: cat)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
        .padding(.vertical, AppSpacing.lg)
        .background(Color.bgPrimary)
    }

    // MARK: — Previous Orders
    private var previousOrderSection: some View {
        VStack(spacing: AppSpacing.md) {
            SectionHeader(title: "Previous Order")
            ForEach(orders) { order in
                PreviousOrderCard(order: order)
                    .padding(.horizontal, AppSpacing.lg)
            }
        }
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.xl)
        .background(Color.bgPrimary)
    }
}

// MARK: - Promo Banner Card

struct PromoBannerCard: View {
    let banner: PromoBanner

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Background gradient
            LinearGradient(colors: banner.bgColors,
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)

            // Decorative dot-grid overlay
            Image(systemName: "circle.grid.3x3.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.white.opacity(0.45))
                .padding([.top, .leading], AppSpacing.md)

            // Content row
            HStack(alignment: .center, spacing: 0) {
                // Left: text
                VStack(alignment: .leading, spacing: 5) {
                    // Tag pill
                    Text(banner.tag)
                        .font(AppFont.labelSM)
                        .foregroundStyle(Color.textSecondary)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Capsule())

                    Spacer()

                    Text(banner.headline)
                        .font(AppFont.bodyMD)
                        .foregroundStyle(Color.textSecondary)

                    Text(banner.offerTitle)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(Color.primaryOrange)

                    Text(banner.offerSubtitle)
                        .font(AppFont.bodySM)
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(.vertical, AppSpacing.xl)
                .padding(.leading, AppSpacing.xl)

                Spacer()

                // Right: symbol in circle
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 106, height: 106)
                    Image(systemName: banner.symbolName)
                        .font(.system(size: 52))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primaryOrange, .primaryLight],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .padding(.trailing, AppSpacing.lg)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
        .cardShadow()
    }
}

// MARK: - Category Tile

struct HomeCategoryTile: View {
    let category: HomeCategory

    var body: some View {
        Button(action: {}) {
            VStack(spacing: AppSpacing.sm) {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(category.color)
                    .frame(width: 76, height: 76)
                    .overlay(
                        Image(systemName: category.icon)
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                    )
                    .softShadow()

                Text(category.name)
                    .font(AppFont.labelMD)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
            }
            .frame(width: 76)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Previous Order Card

struct PreviousOrderCard: View {
    let order: PreviousOrder

    var body: some View {
        HStack(spacing: 0) {

            // Left content
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Status
                HStack(spacing: 5) {
                    Circle()
                        .fill(order.statusColor)
                        .frame(width: 8, height: 8)
                    Text(order.status)
                        .font(AppFont.labelMD)
                        .foregroundStyle(order.statusColor)
                }

                Text(order.date)
                    .font(AppFont.bodySM)
                    .foregroundStyle(Color.textSecondary)

                Spacer(minLength: AppSpacing.sm)

                // Item icon circles
                HStack(spacing: AppSpacing.xs) {
                    ForEach(order.itemIcons.prefix(3), id: \.self) { sym in
                        Circle()
                            .fill(Color.bgInput)
                            .frame(width: 46, height: 46)
                            .overlay(
                                Image(systemName: sym)
                                    .font(.system(size: 22))
                                    .foregroundStyle(Color.primaryOrange)
                            )
                    }
                    if order.extraCount > 0 {
                        Circle()
                            .fill(Color.primaryPastel)
                            .frame(width: 46, height: 46)
                            .overlay(
                                Text("+\(order.extraCount)")
                                    .font(AppFont.labelSM)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.primaryOrange)
                            )
                    }
                }
            }
            .padding(AppSpacing.lg)
            .frame(maxHeight: .infinity, alignment: .topLeading)

            Spacer()

            // Right promo strip
            if let label = order.promoLabel {
                ZStack {
                    Color.primaryOrange
                    Text(label)
                        .font(AppFont.labelSM)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(-90))
                        .fixedSize()
                }
                .frame(width: 38)
                .frame(maxHeight: .infinity)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: AppRadius.lg,
                        topTrailingRadius: AppRadius.lg
                    )
                )
            }
        }
        .frame(maxWidth: .infinity, minHeight: 130)
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .cardShadow()
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
