import SwiftUI

struct OrderSuccessView: View {
    let order: Order
    @EnvironmentObject var orderVM: OrderViewModel

    @State private var checkmarkScale: CGFloat = 0.0
    @State private var contentOpacity: Double = 0
    @State private var navigateToDetail = false

    // Dismiss the entire navigation stack back to Cart tab
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Animated checkmark
            ZStack {
                Circle()
                    .fill(Color(hex: "#ECFDF5") ?? .green.opacity(0.1))
                    .frame(width: 140, height: 140)
                Circle()
                    .fill(Color(hex: "#D1FAE5") ?? .green.opacity(0.2))
                    .frame(width: 110, height: 110)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(Color(hex: "#10B981") ?? .green)
            }
            .scaleEffect(checkmarkScale)

            VStack(spacing: AppSpacing.sm) {
                Text("Order Placed!")
                    .font(AppFont.h1)
                    .foregroundColor(.textPrimary)

                Text("#\(order.orderNumber)")
                    .font(AppFont.priceMD)
                    .foregroundColor(.primaryOrange)
            }
            .padding(.top, AppSpacing.x3l)
            .opacity(contentOpacity)

            // Delivery info card
            VStack(spacing: AppSpacing.md) {
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.primaryOrange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Estimated Delivery")
                            .font(AppFont.caption)
                            .foregroundColor(.textSecondary)
                        Text(order.estimatedDelivery.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                            .font(AppFont.labelLG)
                            .foregroundColor(.textPrimary)
                    }
                    Spacer()
                }
                .padding(AppSpacing.lg)
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()

                HStack(spacing: AppSpacing.md) {
                    Image(systemName: order.paymentMethod.icon)
                        .font(.system(size: 32))
                        .foregroundColor(.primaryOrange)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Payment")
                            .font(AppFont.caption)
                            .foregroundColor(.textSecondary)
                        Text(order.paymentMethod.rawValue)
                            .font(AppFont.labelLG)
                            .foregroundColor(.textPrimary)
                    }
                    Spacer()
                    Text("₹\(Int(order.total))")
                        .font(AppFont.priceMD)
                        .foregroundColor(.textPrimary)
                }
                .padding(AppSpacing.lg)
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.xl)
            .opacity(contentOpacity)

            Spacer()

            // Action buttons
            VStack(spacing: AppSpacing.md) {
                AppButton(title: "Track Order") {
                    navigateToDetail = true
                }
                .padding(.horizontal, AppSpacing.lg)

                Button("Continue Shopping") {
                    // Pop all the way back
                    dismiss()
                    dismiss()
                }
                .font(AppFont.labelLG)
                .foregroundColor(.primaryOrange)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.primaryPastel)
                .cornerRadius(AppRadius.lg)
                .padding(.horizontal, AppSpacing.lg)
            }
            .padding(.bottom, AppSpacing.x3l)
            .opacity(contentOpacity)
        }
        .background(Color.bgPrimary)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Order Confirmed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToDetail) {
            OrderDetailView(order: order)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
                checkmarkScale = 1.0
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                contentOpacity = 1.0
            }
        }
    }
}
