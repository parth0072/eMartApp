import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @EnvironmentObject var storeVM: StoreViewModel
    @EnvironmentObject var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedImageIndex = 0
    @State private var selectedColor: String?
    @State private var selectedSize: String?
    @State private var showReviewSheet = false
    @State private var addedToCart = false
    @State private var expandDescription = false

    var reviews: [Review] { storeVM.reviews(for: product.id) }
    var isWishlisted: Bool { storeVM.isWishlisted(product.id) }
    var related: [Product] { storeVM.relatedProducts(for: product) }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageCarousel
                infoSection
                Divider().padding(.vertical, AppSpacing.sm)
                descriptionSection
                if product.colors != nil || product.sizes != nil {
                    Divider().padding(.vertical, AppSpacing.sm)
                    variantSection
                }
                Divider().padding(.vertical, AppSpacing.sm)
                reviewsSection
                if !related.isEmpty {
                    Divider().padding(.vertical, AppSpacing.sm)
                    relatedSection
                }
                // Bottom spacer for sticky bar
                Color.clear.frame(height: 90)
            }
        }
        .background(Color.bgPrimary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { storeVM.toggleWishlist(product.id) } label: {
                    Image(systemName: isWishlisted ? "heart.fill" : "heart")
                        .foregroundColor(isWishlisted ? .red : .white)
                }
            }
        }
        .overlay(alignment: .bottom) { stickyBar }
        .sheet(isPresented: $showReviewSheet) {
            WriteReviewSheet(product: product, storeVM: storeVM)
                .presentationDetents([.large])
        }
        .onAppear {
            selectedColor = product.colors?.first
            selectedSize = product.sizes?.first
        }
    }

    // MARK: Image Carousel
    private var imageCarousel: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedImageIndex) {
                ForEach(Array(product.images.enumerated()), id: \.offset) { idx, img in
                    ZStack {
                        LinearGradient(
                            colors: [Color.bgInput, Color.bgPrimary],
                            startPoint: .top, endPoint: .bottom
                        )
                        Image(systemName: img)
                            .font(.system(size: 100))
                            .foregroundColor(Color.primaryOrange.opacity(0.8))
                    }
                    .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            .background(Color.bgInput)

            // Page dots
            if product.images.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<product.images.count, id: \.self) { i in
                        Circle()
                            .fill(i == selectedImageIndex ? Color.primaryOrange : Color.borderMedium)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, AppSpacing.md)
            }

            // Discount badge
            if product.discountPercent > 0 {
                VStack {
                    HStack {
                        TagView(text: "-\(product.discountPercent)%", variant: .discount)
                            .padding(AppSpacing.md)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }

    // MARK: Info Section
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(product.brand.uppercased())
                .font(AppFont.labelSM)
                .foregroundColor(.textSecondary)
                .tracking(1)

            Text(product.name)
                .font(AppFont.h2)
                .foregroundColor(.textPrimary)

            HStack(spacing: AppSpacing.sm) {
                RatingBadge(rating: product.rating, reviewCount: product.reviewCount)
                Spacer()
                if product.isNew {
                    TagView(text: "NEW", variant: .new)
                }
                if product.isBestSeller {
                    TagView(text: "BESTSELLER", variant: .hot)
                }
            }

            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
                Text("₹\(Int(product.price))")
                    .font(AppFont.priceLG)
                    .foregroundColor(.textPrimary)

                if product.discountPercent > 0 {
                    Text("₹\(Int(product.originalPrice))")
                        .font(AppFont.bodyMD)
                        .foregroundColor(.textTertiary)
                        .strikethrough()

                    Text("\(product.discountPercent)% off")
                        .font(AppFont.labelMD)
                        .foregroundColor(Color(hex: "#10B981") ?? .green)
                }
            }

            // Stock
            HStack(spacing: AppSpacing.xs) {
                Circle()
                    .fill(product.isOutOfStock ? Color.error : Color(hex: "#10B981") ?? .green)
                    .frame(width: 7, height: 7)
                Text(product.isOutOfStock ? "Out of Stock" : "In Stock (\(product.stock) left)")
                    .font(AppFont.bodySM)
                    .foregroundColor(product.isOutOfStock ? .error : .textSecondary)
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
    }

    // MARK: Description
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Description")
                .font(AppFont.h4)
                .foregroundColor(.textPrimary)

            Text(product.description)
                .font(AppFont.bodyMD)
                .foregroundColor(.textSecondary)
                .lineSpacing(5)
                .lineLimit(expandDescription ? nil : 3)

            Button(expandDescription ? "Show less" : "Read more") {
                expandDescription.toggle()
            }
            .font(AppFont.labelMD)
            .foregroundColor(.primaryOrange)
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
    }

    // MARK: Variants
    private var variantSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            if let colors = product.colors {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Color: \(selectedColor ?? "")")
                        .font(AppFont.labelLG)
                        .foregroundColor(.textPrimary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(colors, id: \.self) { color in
                                Button {
                                    selectedColor = color
                                } label: {
                                    Text(color)
                                        .font(AppFont.labelMD)
                                        .padding(.horizontal, AppSpacing.md)
                                        .padding(.vertical, AppSpacing.sm)
                                        .background(selectedColor == color ? Color.primaryOrange : Color.bgInput)
                                        .foregroundColor(selectedColor == color ? .white : .textPrimary)
                                        .cornerRadius(AppRadius.full)
                                        .overlay(
                                            Capsule()
                                                .stroke(selectedColor == color ? Color.primaryOrange : Color.borderLight, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                }
            }

            if let sizes = product.sizes {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Size: \(selectedSize ?? "")")
                        .font(AppFont.labelLG)
                        .foregroundColor(.textPrimary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppSpacing.sm) {
                            ForEach(sizes, id: \.self) { size in
                                Button {
                                    selectedSize = size
                                } label: {
                                    Text(size)
                                        .font(AppFont.labelMD)
                                        .frame(minWidth: 44, minHeight: 36)
                                        .padding(.horizontal, AppSpacing.sm)
                                        .background(selectedSize == size ? Color.primaryOrange : Color.bgCard)
                                        .foregroundColor(selectedSize == size ? .white : .textPrimary)
                                        .cornerRadius(AppRadius.sm)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.sm)
                                                .stroke(selectedSize == size ? Color.primaryOrange : Color.borderMedium, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
    }

    // MARK: Reviews
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            HStack {
                Text("Reviews (\(reviews.count))")
                    .font(AppFont.h4)
                    .foregroundColor(.textPrimary)
                Spacer()
                Button("Write a Review") { showReviewSheet = true }
                    .font(AppFont.labelMD)
                    .foregroundColor(.primaryOrange)
            }

            // Avg rating
            HStack(spacing: AppSpacing.lg) {
                VStack(spacing: 4) {
                    Text(String(format: "%.1f", product.rating))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.textPrimary)
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: Double(i) <= product.rating ? "star.fill" : "star")
                                .font(.system(size: 12))
                                .foregroundColor(.ratingYellow)
                        }
                    }
                    Text("\(product.reviewCount) reviews")
                        .font(AppFont.caption)
                        .foregroundColor(.textTertiary)
                }

                Divider().frame(height: 70)

                VStack(spacing: 4) {
                    ForEach([5, 4, 3, 2, 1], id: \.self) { star in
                        HStack(spacing: AppSpacing.sm) {
                            Text("\(star)")
                                .font(AppFont.caption)
                                .foregroundColor(.textSecondary)
                                .frame(width: 12)
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.ratingYellow)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color.bgInput).frame(height: 4)
                                    Capsule()
                                        .fill(Color.ratingYellow)
                                        .frame(width: geo.size.width * barWidth(for: star), height: 4)
                                }
                            }
                            .frame(height: 4)
                        }
                    }
                }
            }

            ForEach(reviews.prefix(3)) { review in
                ReviewRow(review: review)
                if review.id != reviews.prefix(3).last?.id {
                    AppDivider()
                }
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
    }

    private func barWidth(for star: Int) -> CGFloat {
        let count = reviews.filter { $0.rating == star }.count
        guard !reviews.isEmpty else { return 0 }
        return CGFloat(count) / CGFloat(reviews.count)
    }

    // MARK: Related
    private var relatedSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            SectionHeader(title: "Related Products")
                .padding(.horizontal, AppSpacing.lg)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(related) { p in
                        NavigationLink(destination: ProductDetailView(product: p)) {
                            ProductCard(
                                product: p,
                                isWishlisted: storeVM.isWishlisted(p.id),
                                onWishlistToggle: { storeVM.toggleWishlist(p.id) },
                                onAddToCart: { cartVM.add(product: p) }
                            )
                            .frame(width: 180)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
        .padding(.vertical, AppSpacing.lg)
        .background(Color.bgCard)
    }

    // MARK: Sticky Bar
    private var stickyBar: some View {
        HStack(spacing: AppSpacing.md) {
            Button {
                cartVM.add(product: product, color: selectedColor, size: selectedSize)
                withAnimation {
                    addedToCart = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    addedToCart = false
                }
            } label: {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: addedToCart ? "checkmark" : "cart.badge.plus")
                    Text(addedToCart ? "Added!" : "Add to Cart")
                        .font(AppFont.labelLG)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(addedToCart ? (Color(hex: "#10B981") ?? .green) : Color.primaryOrange.opacity(0.12))
                .foregroundColor(addedToCart ? .white : .primaryOrange)
                .cornerRadius(AppRadius.lg)
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .stroke(addedToCart ? Color.clear : Color.primaryOrange, lineWidth: 1.5)
                )
            }
            .disabled(product.isOutOfStock)

            NavigationLink(destination: CheckoutDirectView(product: product, color: selectedColor, size: selectedSize)) {
                Text("Buy Now")
                    .font(AppFont.labelLG)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(product.isOutOfStock ? Color.borderMedium : Color.primaryOrange)
                    .cornerRadius(AppRadius.lg)
            }
            .disabled(product.isOutOfStock)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .top)
    }
}

// MARK: - Review Row
private struct ReviewRow: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                // Avatar
                ZStack {
                    Circle().fill(Color.primaryPastel)
                        .frame(width: 36, height: 36)
                    Text(String(review.userName.prefix(1)))
                        .font(AppFont.labelLG)
                        .foregroundColor(.primaryOrange)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(review.userName)
                        .font(AppFont.labelMD)
                        .foregroundColor(.textPrimary)
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { i in
                            Image(systemName: i <= review.rating ? "star.fill" : "star")
                                .font(.system(size: 10))
                                .foregroundColor(.ratingYellow)
                        }
                    }
                }

                Spacer()

                if review.isVerified {
                    Label("Verified", systemImage: "checkmark.seal.fill")
                        .font(AppFont.caption)
                        .foregroundColor(Color(hex: "#10B981") ?? .green)
                }
            }

            Text(review.title)
                .font(AppFont.labelMD)
                .foregroundColor(.textPrimary)

            Text(review.body)
                .font(AppFont.bodySM)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
    }
}

// MARK: - Write Review Sheet
private struct WriteReviewSheet: View {
    let product: Product
    let storeVM: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authVM: AuthViewModel

    @State private var rating = 5
    @State private var title = ""
    @State private var body_ = ""
    @State private var submitted = false

    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.xl) {
                if submitted {
                    VStack(spacing: AppSpacing.lg) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.ratingYellow)
                        Text("Review Submitted!")
                            .font(AppFont.h2)
                        Text("Thank you for your feedback.")
                            .font(AppFont.bodyMD)
                            .foregroundColor(.textSecondary)
                        AppButton(title: "Done") { dismiss() }
                    }
                    .padding(AppSpacing.xl)
                } else {
                    ScrollView {
                        VStack(spacing: AppSpacing.xl) {
                            // Star picker
                            VStack(spacing: AppSpacing.sm) {
                                Text("Your Rating")
                                    .font(AppFont.labelLG)
                                    .foregroundColor(.textPrimary)
                                HStack(spacing: AppSpacing.lg) {
                                    ForEach(1...5, id: \.self) { i in
                                        Button { rating = i } label: {
                                            Image(systemName: i <= rating ? "star.fill" : "star")
                                                .font(.system(size: 32))
                                                .foregroundColor(.ratingYellow)
                                        }
                                    }
                                }
                            }

                            AppTextField(label: "Review Title", placeholder: "Summarise your experience",
                                         text: $title, leadingIcon: "text.quote")
                            AppTextField(label: "Review", placeholder: "Share details about the product…",
                                         text: $body_, leadingIcon: "text.alignleft")

                            AppButton(title: "Submit Review",
                                      isDisabled: title.isEmpty || body_.isEmpty) {
                                submitReview()
                            }
                        }
                        .padding(AppSpacing.xl)
                    }
                }
            }
            .navigationTitle("Write a Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(AppFont.labelMD)
                        .foregroundColor(.primaryOrange)
                }
            }
        }
    }

    private func submitReview() {
        let review = Review(
            productId: product.id,
            userId: authVM.currentUser?.id ?? UUID(),
            userName: authVM.currentUser?.firstName ?? "User",
            rating: rating, title: title, body: body_,
            date: Date(), isVerified: true
        )
        storeVM.addReview(review)
        withAnimation { submitted = true }
    }
}

// MARK: - Buy Now Direct (adds to cart and goes to checkout)
struct CheckoutDirectView: View {
    let product: Product
    let color: String?
    let size: String?
    @EnvironmentObject var cartVM: CartViewModel

    var body: some View {
        CheckoutView()
            .onAppear {
                if !cartVM.contains(product.id) {
                    cartVM.add(product: product, color: color, size: size)
                }
            }
    }
}
