import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var storeVM: StoreViewModel
    @State private var promoInput = ""
    @State private var promoError = ""
    @State private var promoSuccess = false
    @State private var navigateToCheckout = false

    var body: some View {
        NavigationStack {
            Group {
                if cartVM.items.isEmpty {
                    emptyState
                } else {
                    cartContent
                }
            }
            .background(Color.bgPrimary)
            .navigationTitle("My Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primaryOrange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToCheckout) {
                CheckoutView()
            }
        }
    }

    // MARK: Empty
    private var emptyState: some View {
        EmptyStateView(
            icon: "cart",
            title: "Your cart is empty",
            message: "Add items you like to your cart and they will show up here.",
            actionTitle: "Start Shopping"
        ) {}
    }

    // MARK: Content
    private var cartContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                // Items
                VStack(spacing: 0) {
                    ForEach(cartVM.items) { item in
                        CartItemRow(item: item)
                        if item.id != cartVM.items.last?.id {
                            AppDivider().padding(.leading, 96)
                        }
                    }
                }
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
                .padding(.horizontal, AppSpacing.lg)

                // Promo code
                promoSection

                // Price summary
                priceSummary

                // Checkout button
                AppButton(title: "Proceed to Checkout  →") {
                    navigateToCheckout = true
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
            .padding(.top, AppSpacing.lg)
        }
    }

    // MARK: Promo
    private var promoSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Promo Code")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)

            if let promo = cartVM.appliedPromo {
                HStack {
                    Image(systemName: "tag.fill").foregroundColor(Color(hex: "#10B981") ?? .green)
                    Text("\(promo.code) applied — \(promo.discountPercent)% off")
                        .font(AppFont.labelMD)
                        .foregroundColor(Color(hex: "#10B981") ?? .green)
                    Spacer()
                    Button("Remove") { cartVM.clearPromo() }
                        .font(AppFont.labelSM)
                        .foregroundColor(.error)
                }
                .padding(AppSpacing.md)
                .background((Color(hex: "#ECFDF5") ?? .green.opacity(0.1)))
                .cornerRadius(AppRadius.md)
            } else {
                HStack(spacing: AppSpacing.sm) {
                    TextField("Enter promo code", text: $promoInput)
                        .font(AppFont.bodyMD)
                        .textInputAutocapitalization(.characters)
                        .padding(.horizontal, AppSpacing.md)
                        .frame(height: 44)
                        .background(Color.bgInput)
                        .cornerRadius(AppRadius.md)

                    Button("Apply") { applyPromo() }
                        .font(AppFont.labelMD)
                        .foregroundColor(.white)
                        .padding(.horizontal, AppSpacing.lg)
                        .frame(height: 44)
                        .background(Color.primaryOrange)
                        .cornerRadius(AppRadius.md)
                }

                if !promoError.isEmpty {
                    Text(promoError)
                        .font(AppFont.bodySM)
                        .foregroundColor(.error)
                }

                // Available codes hint
                Text("Try: EMART10 • SAVE20 • FIRST50")
                    .font(AppFont.caption)
                    .foregroundColor(.textTertiary)
            }
        }
        .padding(AppSpacing.lg)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: Price Summary
    private var priceSummary: some View {
        VStack(spacing: 0) {
            Text("Price Details")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.lg)

            AppDivider()

            VStack(spacing: AppSpacing.md) {
                PriceRow(label: "Subtotal (\(cartVM.itemCount) items)",
                         value: "₹\(Int(cartVM.subtotal))")
                if cartVM.discount > 0 {
                    PriceRow(label: "Discount", value: "−₹\(Int(cartVM.discount))",
                             valueColor: Color(hex: "#10B981") ?? .green)
                }
                PriceRow(label: "Tax (5%)", value: "₹\(Int(cartVM.tax))")
                PriceRow(label: "Delivery", value: "FREE",
                         valueColor: Color(hex: "#10B981") ?? .green)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)

            AppDivider()

            HStack {
                Text("Total Amount")
                    .font(AppFont.h4).foregroundColor(.textPrimary)
                Spacer()
                Text("₹\(Int(cartVM.total(deliveryCharge: 0)))")
                    .font(AppFont.priceLG).foregroundColor(.textPrimary)
            }
            .padding(AppSpacing.lg)
        }
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
        .padding(.horizontal, AppSpacing.lg)
    }

    private func applyPromo() {
        promoError = ""
        let success = cartVM.applyPromoCode(promoInput)
        if !success {
            promoError = "Invalid or expired promo code"
        } else {
            promoInput = ""
        }
    }
}

// MARK: - Cart Item Row
private struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartVM: CartViewModel

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Product image
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(Color.bgInput)
                    .frame(width: 72, height: 72)
                Image(systemName: item.product.primaryImage)
                    .font(.system(size: 28))
                    .foregroundColor(Color.primaryOrange.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(item.product.name)
                    .font(AppFont.labelMD)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)

                if let color = item.selectedColor {
                    Text("Color: \(color)")
                        .font(AppFont.caption).foregroundColor(.textTertiary)
                }
                if let size = item.selectedSize {
                    Text("Size: \(size)")
                        .font(AppFont.caption).foregroundColor(.textTertiary)
                }

                Text("₹\(Int(item.product.price))")
                    .font(AppFont.priceSM)
                    .foregroundColor(.textPrimary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppSpacing.sm) {
                Button {
                    cartVM.remove(id: item.id)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(.error)
                }

                QuantityStepper(quantity: Binding(
                    get: { item.quantity },
                    set: { cartVM.updateQuantity(id: item.id, quantity: $0) }
                ))
                .scaleEffect(0.85)
            }
        }
        .padding(AppSpacing.md)
    }
}

// MARK: - Price Row
struct PriceRow: View {
    let label: String
    let value: String
    var valueColor: Color = .textPrimary

    var body: some View {
        HStack {
            Text(label).font(AppFont.bodyMD).foregroundColor(.textSecondary)
            Spacer()
            Text(value).font(AppFont.labelMD).foregroundColor(valueColor)
        }
    }
}
