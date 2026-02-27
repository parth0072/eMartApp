import SwiftUI

// MARK: - Product Model (placeholder)
struct Product: Identifiable {
    let id = UUID()
    var name: String
    var brand: String
    var price: Double
    var originalPrice: Double?
    var rating: Double
    var reviewCount: Int
    var imageName: String       // SF Symbol or asset name
    var isFavorite: Bool = false
    var isNew: Bool = false
    var stockCount: Int = 10

    var discountPercent: Int? {
        guard let orig = originalPrice, orig > price else { return nil }
        return Int(((orig - price) / orig) * 100)
    }
    var isOutOfStock: Bool { stockCount == 0 }
}

// MARK: - Vertical Product Card (grid)
struct ProductCard: View {
    let product: Product
    var onFavorite: (() -> Void)? = nil
    var onAddToCart: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil

    @State private var isFav: Bool = false

    init(product: Product, onFavorite: (() -> Void)? = nil,
         onAddToCart: (() -> Void)? = nil, onTap: (() -> Void)? = nil) {
        self.product    = product
        self.onFavorite = onFavorite
        self.onAddToCart = onAddToCart
        self.onTap      = onTap
        _isFav = State(initialValue: product.isFavorite)
    }

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                // Image area
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(Color.bgInput)
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: product.imageName)
                                .font(.system(size: 60))
                                .foregroundStyle(Color.textTertiary)
                        )

                    // Badges top-left
                    VStack(alignment: .leading, spacing: 4) {
                        if let pct = product.discountPercent {
                            DiscountBadge(percent: pct)
                        }
                        if product.isNew {
                            TagView(text: "NEW", variant: .new)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Favourite button top-right
                    Button {
                        isFav.toggle()
                        onFavorite?()
                    } label: {
                        Image(systemName: isFav ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isFav ? Color.error : Color.textTertiary)
                            .frame(width: 34, height: 34)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                    }
                    .padding(8)
                }

                // Info
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(product.brand)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.textTertiary)
                        .padding(.top, AppSpacing.sm)

                    Text(product.name)
                        .font(AppFont.labelLG)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    RatingBadge(rating: product.rating, reviewCount: product.reviewCount)

                    HStack(alignment: .bottom, spacing: AppSpacing.xs) {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(AppFont.priceSM)
                            .foregroundStyle(Color.primaryOrange)

                        if let orig = product.originalPrice {
                            Text("$\(String(format: "%.2f", orig))")
                                .font(AppFont.bodySM)
                                .foregroundStyle(Color.textTertiary)
                                .strikethrough()
                        }

                        Spacer()

                        // Add to cart mini button
                        Button {
                            onAddToCart?()
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .background(
                                    product.isOutOfStock
                                    ? AnyShapeStyle(Color.textTertiary)
                                    : AnyShapeStyle(LinearGradient(colors: [.primaryOrange, .primaryDark],
                                                                   startPoint: .topLeading, endPoint: .bottomTrailing))
                                )
                                .clipShape(RoundedRectangle(cornerRadius: AppRadius.xs))
                        }
                        .disabled(product.isOutOfStock)
                    }
                }
                .padding(.horizontal, AppSpacing.sm)
                .padding(.bottom, AppSpacing.sm)
            }
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Horizontal Product Card (list)
struct ProductCardHorizontal: View {
    let product: Product
    var onFavorite: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil

    @State private var isFav: Bool = false

    init(product: Product, onFavorite: (() -> Void)? = nil, onTap: (() -> Void)? = nil) {
        self.product    = product
        self.onFavorite = onFavorite
        self.onTap      = onTap
        _isFav = State(initialValue: product.isFavorite)
    }

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: AppSpacing.md) {
                // Image
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(Color.bgInput)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: product.imageName)
                                .font(.system(size: 36))
                                .foregroundStyle(Color.textTertiary)
                        )
                    if let pct = product.discountPercent {
                        DiscountBadge(percent: pct)
                            .padding(6)
                    }
                }

                // Info
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(product.brand)
                        .font(AppFont.caption)
                        .foregroundStyle(Color.textTertiary)

                    Text(product.name)
                        .font(AppFont.labelLG)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(2)

                    RatingBadge(rating: product.rating, reviewCount: product.reviewCount)

                    HStack(alignment: .bottom) {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(AppFont.priceSM)
                            .foregroundStyle(Color.primaryOrange)

                        if let orig = product.originalPrice {
                            Text("$\(String(format: "%.2f", orig))")
                                .font(AppFont.bodySM)
                                .foregroundStyle(Color.textTertiary)
                                .strikethrough()
                        }
                    }
                }

                Spacer()

                // Fav
                Button {
                    isFav.toggle()
                    onFavorite?()
                } label: {
                    Image(systemName: isFav ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundStyle(isFav ? Color.error : Color.textTertiary)
                }
            }
            .padding(AppSpacing.md)
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    let p = Product(name: "Air Max 270 React", brand: "Nike",
                    price: 89.99, originalPrice: 129.99,
                    rating: 4.7, reviewCount: 234,
                    imageName: "shoe", isNew: true)
    let p2 = Product(name: "Wireless Pro Headphones", brand: "Sony",
                     price: 199.00, originalPrice: 249.00,
                     rating: 4.5, reviewCount: 89,
                     imageName: "headphones")

    ScrollView {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ProductCard(product: p)
            ProductCard(product: p2)
        }
        .padding()

        VStack(spacing: 12) {
            ProductCardHorizontal(product: p)
            ProductCardHorizontal(product: p2)
        }
        .padding()
    }
    .background(Color.bgPrimary)
}
