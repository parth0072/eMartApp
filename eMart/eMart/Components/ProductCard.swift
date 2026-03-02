import SwiftUI

// MARK: - Vertical Product Card (grid)
struct ProductCard: View {
    let product: Product
    var isWishlisted: Bool = false
    var onWishlistToggle: (() -> Void)? = nil
    var onAddToCart: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: 0) {
                // Image area
                ZStack(alignment: .topTrailing) {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(Color.bgInput)
                        .frame(height: 160)
                        .overlay(
                            Image(systemName: product.primaryImage)
                                .font(.system(size: 60))
                                .foregroundStyle(Color.textTertiary)
                        )

                    // Badges top-left
                    VStack(alignment: .leading, spacing: 4) {
                        if product.discountPercent > 0 {
                            DiscountBadge(percent: product.discountPercent)
                        }
                        if product.isNew {
                            TagView(text: "NEW", variant: .new)
                        }
                        if product.isBestSeller {
                            TagView(text: "BESTSELLER", variant: .hot)
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Wishlist button top-right
                    Button {
                        onWishlistToggle?()
                    } label: {
                        Image(systemName: isWishlisted ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(isWishlisted ? Color.error : Color.textTertiary)
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
                        Text("₹\(Int(product.price))")
                            .font(AppFont.priceSM)
                            .foregroundStyle(Color.primaryOrange)

                        if product.originalPrice > product.price {
                            Text("₹\(Int(product.originalPrice))")
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
    var isWishlisted: Bool = false
    var onWishlistToggle: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: AppSpacing.md) {
                // Image
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(Color.bgInput)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: product.primaryImage)
                                .font(.system(size: 36))
                                .foregroundStyle(Color.textTertiary)
                        )
                    if product.discountPercent > 0 {
                        DiscountBadge(percent: product.discountPercent)
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
                        Text("₹\(Int(product.price))")
                            .font(AppFont.priceSM)
                            .foregroundStyle(Color.primaryOrange)

                        if product.originalPrice > product.price {
                            Text("₹\(Int(product.originalPrice))")
                                .font(AppFont.bodySM)
                                .foregroundStyle(Color.textTertiary)
                                .strikethrough()
                        }
                    }
                }

                Spacer()

                // Wishlist
                Button {
                    onWishlistToggle?()
                } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundStyle(isWishlisted ? Color.error : Color.textTertiary)
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
