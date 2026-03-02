import SwiftUI

struct SearchView: View {
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var results: [Product] = []
    @FocusState private var isSearchFocused: Bool

    private var showRecents: Bool { query.isEmpty }
    private var showResults: Bool { !query.isEmpty }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar row
                HStack(spacing: AppSpacing.md) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }

                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.textSecondary)
                        TextField("Search products, brands…", text: $query)
                            .font(AppFont.bodyMD)
                            .focused($isSearchFocused)
                            .submitLabel(.search)
                            .onSubmit { submitSearch() }
                        if !query.isEmpty {
                            Button { query = "" } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.textTertiary)
                            }
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .frame(height: 44)
                    .background(Color.bgInput)
                    .cornerRadius(AppRadius.lg)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
                .background(Color.bgCard)
                .softShadow()

                AppDivider()

                ScrollView {
                    if showRecents {
                        recentsSection
                    } else if results.isEmpty {
                        emptyResultsView
                    } else {
                        resultsGrid
                    }
                }
            }
            .background(Color.bgPrimary)
            .navigationBarHidden(true)
            .onChange(of: query) { _ in performSearch() }
            .onAppear { isSearchFocused = true }
        }
    }

    // MARK: Recents
    private var recentsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !storeVM.recentSearches.isEmpty {
                HStack {
                    Text("Recent Searches")
                        .font(AppFont.labelLG)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Button("Clear") { storeVM.clearRecentSearches() }
                        .font(AppFont.labelMD)
                        .foregroundColor(.primaryOrange)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)

                ForEach(storeVM.recentSearches, id: \.self) { term in
                    SearchSuggestionRow(text: term, isRecent: true) {
                        query = term
                        performSearch()
                    }
                }

                AppDivider().padding(.top, AppSpacing.lg)
            }

            // Popular searches
            Text("Popular Searches")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)

            let popular = ["iPhone 15", "Nike Shoes", "MacBook", "Yoga Mat", "Instant Pot", "Atomic Habits"]
            FlowLayout(items: popular) { term in
                Button {
                    query = term
                    performSearch()
                } label: {
                    Text(term)
                        .font(AppFont.labelMD)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.sm)
                        .background(Color.bgInput)
                        .cornerRadius(AppRadius.full)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
        }
    }

    // MARK: Results
    private var resultsGrid: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("\(results.count) result\(results.count == 1 ? "" : "s") for \"\(query)\"")
                .font(AppFont.labelMD)
                .foregroundColor(.textSecondary)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                      spacing: AppSpacing.md) {
                ForEach(results) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        ProductCard(
                            product: product,
                            isWishlisted: storeVM.isWishlisted(product.id),
                            onWishlistToggle: { storeVM.toggleWishlist(product.id) },
                            onAddToCart: { cartVM.add(product: product) }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
    }

    // MARK: Empty
    private var emptyResultsView: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No results for \"\(query)\"",
            message: "Try different keywords or browse categories"
        )
        .padding(.top, AppSpacing.x4l)
    }

    // MARK: Actions
    private func performSearch() {
        results = storeVM.search(query: query)
    }

    private func submitSearch() {
        storeVM.addRecentSearch(query)
        performSearch()
    }
}

// MARK: - Flow Layout (tag cloud)
private struct FlowLayout<T: Hashable, Content: View>: View {
    let items: [T]
    let content: (T) -> Content

    init(items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.content = content
    }

    var body: some View {
        var width: CGFloat = 0
        var rows: [[T]] = [[]]

        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .alignmentGuide(.leading) { d in
                            if abs(width - d.width) > geo.size.width {
                                width = 0
                                rows.append([])
                            }
                            let result = width
                            if item == items.last { width = 0 } else { width -= d.width + 8 }
                            return result
                        }
                        .alignmentGuide(.top) { _ in
                            let result = CGFloat(rows.count - 1) * 40
                            return -result
                        }
                }
            }
        }
        .frame(height: CGFloat(max(1, (items.count + 2) / 3) * 40))
    }
}
