import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                // Order header card
                headerCard
                    .padding(.top, AppSpacing.lg)

                // Tracking progress
                if order.status != .cancelled {
                    trackingCard
                }

                // Items
                itemsCard

                // Delivery address
                addressCard

                // Payment
                paymentCard

                // Price breakdown
                priceCard
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.x4l)
        }
        .background(Color.bgPrimary)
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: Header Card
    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("#\(order.orderNumber)")
                    .font(AppFont.h3)
                    .foregroundColor(.textPrimary)
                Text("Placed on \(order.placedDate.formatted(.dateTime.day().month(.wide).year()))")
                    .font(AppFont.bodySM)
                    .foregroundColor(.textSecondary)
                if order.status.isActive {
                    Text("Est. delivery: \(order.estimatedDeliveryString)")
                        .font(AppFont.bodySM)
                        .foregroundColor(.primaryOrange)
                }
            }
            Spacer()
            StatusBadge(status: order.status)
        }
        .padding(AppSpacing.lg)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }

    // MARK: Tracking Card
    private var trackingCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            Text("Order Tracking")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)

            ForEach(order.trackingSteps, id: \.id) { step in
                TrackingStepRow(step: step)
            }
        }
        .padding(AppSpacing.lg)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }

    // MARK: Items Card
    private var itemsCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Order Items (\(order.items.count))")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppSpacing.md)

            AppDivider()

            ForEach(order.items) { item in
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.sm)
                            .fill(Color.bgInput)
                            .frame(width: 56, height: 56)
                        Image(systemName: item.product.primaryImage)
                            .font(.system(size: 22))
                            .foregroundColor(.primaryOrange.opacity(0.7))
                    }

                    VStack(alignment: .leading, spacing: 2) {
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
                        Text("Qty: \(item.quantity)")
                            .font(AppFont.caption).foregroundColor(.textSecondary)
                    }

                    Spacer()

                    Text("₹\(Int(item.price * Double(item.quantity)))")
                        .font(AppFont.labelMD)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)

                if item.id != order.items.last?.id {
                    AppDivider().padding(.leading, AppSpacing.lg)
                }
            }
        }
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }

    // MARK: Address Card
    private var addressCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: order.deliveryAddress.label.icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)
                .frame(width: 44, height: 44)
                .background(Color.primaryPastel)
                .cornerRadius(AppRadius.sm)

            VStack(alignment: .leading, spacing: 2) {
                Text("Delivery Address")
                    .font(AppFont.caption)
                    .foregroundColor(.textSecondary)
                Text(order.deliveryAddress.label.rawValue)
                    .font(AppFont.labelMD)
                    .foregroundColor(.textPrimary)
                Text("\(order.deliveryAddress.displayCity), \(order.deliveryAddress.displayArea)")
                    .font(AppFont.bodySM)
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }

    // MARK: Payment Card
    private var paymentCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: order.paymentMethod.icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryOrange)
                .frame(width: 44, height: 44)
                .background(Color.primaryPastel)
                .cornerRadius(AppRadius.sm)

            VStack(alignment: .leading, spacing: 2) {
                Text("Payment Method")
                    .font(AppFont.caption)
                    .foregroundColor(.textSecondary)
                Text(order.paymentMethod.rawValue)
                    .font(AppFont.labelMD)
                    .foregroundColor(.textPrimary)
            }

            Spacer()
        }
        .padding(AppSpacing.lg)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }

    // MARK: Price Card
    private var priceCard: some View {
        VStack(spacing: 0) {
            Text("Price Breakdown")
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppSpacing.lg)

            AppDivider()

            VStack(spacing: AppSpacing.md) {
                PriceRow(label: "Subtotal", value: "₹\(Int(order.subtotal))")
                if order.discount > 0 {
                    PriceRow(label: "Discount", value: "−₹\(Int(order.discount))",
                             valueColor: Color(hex: "#10B981") ?? .green)
                }
                PriceRow(label: "Tax (5%)", value: "₹\(Int(order.tax))")
                PriceRow(label: "Delivery",
                         value: order.deliveryCharge == 0 ? "FREE" : "₹\(Int(order.deliveryCharge))",
                         valueColor: order.deliveryCharge == 0 ? (Color(hex: "#10B981") ?? .green) : .textPrimary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)

            AppDivider()

            HStack {
                Text("Total").font(AppFont.h4)
                Spacer()
                Text("₹\(Int(order.total))").font(AppFont.priceLG)
            }
            .padding(AppSpacing.lg)
        }
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }
}

// MARK: - Tracking Step Row
private struct TrackingStepRow: View {
    let step: TrackingStep
    private let isLast: Bool

    init(step: TrackingStep) {
        self.step = step
        // can't easily know isLast without index; just skip last connector
        self.isLast = false
    }

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Step icon + connector
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(step.isCurrent
                              ? Color.primaryOrange
                              : step.isCompleted
                                ? (Color(hex: "#10B981") ?? .green)
                                : Color.borderLight)
                        .frame(width: 28, height: 28)

                    Image(systemName: step.isCompleted ? "checkmark" : step.status.icon)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(step.isCompleted || step.isCurrent ? .white : .textTertiary)
                }

                if !isLast {
                    Rectangle()
                        .fill(step.isCompleted ? (Color(hex: "#10B981") ?? .green) : Color.borderLight)
                        .frame(width: 2, height: 28)
                }
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(AppFont.labelMD)
                    .foregroundColor(step.isCompleted || step.isCurrent ? .textPrimary : .textTertiary)
                Text(step.subtitle)
                    .font(AppFont.caption)
                    .foregroundColor(.textTertiary)
            }
            .padding(.top, 4)

            Spacer()
        }
    }
}
