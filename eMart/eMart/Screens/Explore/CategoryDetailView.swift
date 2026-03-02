import SwiftUI

enum SortOption: String, CaseIterable {
    case relevance  = "Relevance"
    case priceLow   = "Price: Low to High"
    case priceHigh  = "Price: High to Low"
    case rating     = "Top Rated"
    case newest     = "Newest"
}

struct CategoryDetailView: View {
    let category: ProductCategory
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var cartVM: CartViewModel

    @State private var selectedSubcategory: String? = nil
    @State private var sortOption: SortOption = .relevance
    @State private var showFilterSheet = false
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 250000
    @State private var minRating: Double = 0

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var filteredProducts: [Product] {
        var list = storeVM.products(for: category.name, subcategory: selectedSubcategory)
        list = list.filter { $0.price >= minPrice && $0.price <= maxPrice && $0.rating >= minRating }
        switch sortOption {
        case .relevance:  break
        case .priceLow:   list.sort { $0.price < $1.price }
        case .priceHigh:  list.sort { $0.price > $1.price }
        case .rating:     list.sort { $0.rating > $1.rating }
        case .newest:     list.sort { $0.isNew && !$1.isNew }
        }
        return list
    }

    var body: some View {
        VStack(spacing: 0) {
            // Subcategory chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    CategoryChip(title: "All", isSelected: selectedSubcategory == nil) {
                        selectedSubcategory = nil
                    }
                    ForEach(category.subcategories) { sub in
                        CategoryChip(title: sub.name, isSelected: selectedSubcategory == sub.name) {
                            selectedSubcategory = (selectedSubcategory == sub.name) ? nil : sub.name
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(Color.bgCard)

            // Sort & Filter bar
            HStack(spacing: 0) {
                Menu {
                    ForEach(SortOption.allCases, id: \.self) { opt in
                        Button(opt.rawValue) { sortOption = opt }
                    }
                } label: {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 13))
                        Text("Sort: \(sortOption.rawValue)")
                            .font(AppFont.labelMD)
                            .lineLimit(1)
                    }
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                }

                Divider().frame(height: 20)

                Button {
                    showFilterSheet = true
                } label: {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 13))
                        Text("Filter")
                            .font(AppFont.labelMD)
                    }
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.md)
                }
            }
            .background(Color.bgCard)
            .overlay(Divider(), alignment: .bottom)

            // Product grid
            if filteredProducts.isEmpty {
                EmptyStateView(icon: "tray", title: "No Products Found",
                               message: "Try adjusting your filters or selecting a different subcategory")
                    .padding(.top, AppSpacing.x4l)
                Spacer()
            } else {
                ScrollView {
                    Text("\(filteredProducts.count) products")
                        .font(AppFont.caption)
                        .foregroundColor(.textTertiary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)

                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(filteredProducts) { product in
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
        }
        .background(Color.bgPrimary)
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showFilterSheet) {
            FilterSheet(minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating)
                .presentationDetents([.medium])
        }
    }
}

// MARK: - Filter Sheet
private struct FilterSheet: View {
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    @Binding var minRating: Double
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                // Price range
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Price Range")
                        .font(AppFont.labelLG).foregroundColor(.textPrimary)
                    HStack {
                        Text("₹\(Int(minPrice))")
                        Spacer()
                        Text("₹\(Int(maxPrice))")
                    }
                    .font(AppFont.bodyMD).foregroundColor(.textSecondary)
                    Slider(value: $maxPrice, in: 0...250000, step: 500)
                        .tint(.primaryOrange)
                }

                // Min rating
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text("Minimum Rating")
                        .font(AppFont.labelLG).foregroundColor(.textPrimary)
                    HStack(spacing: AppSpacing.sm) {
                        ForEach([0.0, 3.0, 3.5, 4.0, 4.5], id: \.self) { r in
                            Button {
                                minRating = r
                            } label: {
                                Text(r == 0 ? "All" : "\(r, specifier: "%.1f")★")
                                    .font(AppFont.labelMD)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.sm)
                                    .background(minRating == r ? Color.primaryOrange : Color.bgInput)
                                    .foregroundColor(minRating == r ? .white : .textPrimary)
                                    .cornerRadius(AppRadius.full)
                            }
                        }
                    }
                }

                AppButton(title: "Apply Filters") { dismiss() }
                    .padding(.top, AppSpacing.md)

                Spacer()
            }
            .padding(AppSpacing.xl)
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Reset") {
                        minPrice = 0; maxPrice = 250000; minRating = 0
                    }
                    .font(AppFont.labelMD).foregroundColor(.primaryOrange)
                }
            }
        }
    }
}
