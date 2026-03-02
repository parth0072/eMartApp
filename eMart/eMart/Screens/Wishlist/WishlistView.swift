import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var cartVM: CartViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            Group {
                if storeVM.wishlistedProducts.isEmpty {
                    emptyState
                } else {
                    productGrid
                }
            }
            .background(Color.bgPrimary)
            .navigationTitle("Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primaryOrange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                if !storeVM.wishlistedProducts.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Text("\(storeVM.wishlistedProducts.count) items")
                            .font(AppFont.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
    }

    // MARK: Empty State
    private var emptyState: some View {
        EmptyStateView(
            icon: "heart",
            title: "Your wishlist is empty",
            message: "Save products you love by tapping the heart icon."
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Grid
    private var productGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                ForEach(storeVM.wishlistedProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        WishlistProductCard(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Wishlist Product Card
private struct WishlistProductCard: View {
    let product: Product
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @State private var addedToCart = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image + remove button
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(Color.bgInput)
                    .frame(height: 140)
                    .overlay(
                        Image(systemName: product.primaryImage)
                            .font(.system(size: 52))
                            .foregroundStyle(Color.textTertiary)
                    )

                // Remove from wishlist
                Button {
                    withAnimation { storeVM.toggleWishlist(product.id) }
                } label: {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.error)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
                .padding(8)

                if product.discountPercent > 0 {
                    DiscountBadge(percent: product.discountPercent)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // Info
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(product.brand)
                    .font(AppFont.caption)
                    .foregroundStyle(Color.textTertiary)
                    .padding(.top, AppSpacing.xs)

                Text(product.name)
                    .font(AppFont.labelMD)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(2)

                HStack {
                    Text("₹\(Int(product.price))")
                        .font(AppFont.priceSM)
                        .foregroundStyle(Color.primaryOrange)
                    Spacer()
                }

                // Add to cart
                Button {
                    cartVM.add(product: product)
                    withAnimation { addedToCart = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { addedToCart = false }
                    }
                } label: {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: addedToCart ? "checkmark" : "cart.badge.plus")
                            .font(.system(size: 12, weight: .semibold))
                        Text(addedToCart ? "Added!" : "Add to Cart")
                            .font(AppFont.labelSM)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(addedToCart
                                ? (Color(hex: "#10B981") ?? .green)
                                : Color.primaryOrange)
                    .cornerRadius(AppRadius.sm)
                }
                .disabled(product.isOutOfStock)
                .padding(.top, AppSpacing.xs)
            }
            .padding(.horizontal, AppSpacing.sm)
            .padding(.bottom, AppSpacing.sm)
        }
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .cardShadow()
    }
}
