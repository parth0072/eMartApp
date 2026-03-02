import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartVM: CartViewModel
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var locationVM: LocationViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var currentStep = 0
    @State private var selectedAddress: Address?
    @State private var selectedPayment: PaymentMethod = .cod
    @State private var selectedDelivery: DeliveryOption = .standard
    @State private var showAddressSheet = false
    @State private var placedOrder: Order?
    @State private var navigateToSuccess = false

    private let steps = ["Address", "Payment", "Review"]

    var body: some View {
        VStack(spacing: 0) {
            // Step indicator
            stepIndicator

            // Content
            TabView(selection: $currentStep) {
                addressStep.tag(0)
                paymentStep.tag(1)
                reviewStep.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentStep)

            // Bottom bar
            bottomBar
        }
        .background(Color.bgPrimary)
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $showAddressSheet) {
            LocationPickerView()
        }
        .navigationDestination(isPresented: $navigateToSuccess) {
            if let order = placedOrder {
                OrderSuccessView(order: order)
            }
        }
        .onAppear {
            selectedAddress = locationVM.selectedAddress
        }
        .onChange(of: locationVM.selectedAddress) { addr in
            selectedAddress = addr
        }
    }

    // MARK: Step Indicator
    private var stepIndicator: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { idx, step in
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(idx <= currentStep ? Color.primaryOrange : Color.bgInput)
                                .frame(width: 28, height: 28)
                            if idx < currentStep {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(idx + 1)")
                                    .font(AppFont.labelSM)
                                    .foregroundColor(idx == currentStep ? .white : .textSecondary)
                            }
                        }
                        Text(step)
                            .font(AppFont.caption)
                            .foregroundColor(idx <= currentStep ? .primaryOrange : .textTertiary)
                    }

                    if idx < steps.count - 1 {
                        Rectangle()
                            .fill(idx < currentStep ? Color.primaryOrange : Color.borderLight)
                            .frame(height: 2)
                            .padding(.bottom, AppSpacing.lg)
                    }
                }
                .frame(maxWidth: idx < steps.count - 1 ? .infinity : nil)
            }
        }
        .padding(.horizontal, AppSpacing.xl)
        .padding(.vertical, AppSpacing.lg)
        .background(Color.bgCard)
        .overlay(Divider(), alignment: .bottom)
    }

    // MARK: Address Step
    private var addressStep: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                SectionHeader(title: "Delivery Address")
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)

                if locationVM.savedAddresses.isEmpty && selectedAddress == nil {
                    EmptyStateView(icon: "mappin.circle", title: "No Address Saved",
                                   message: "Add a delivery address to continue",
                                   actionTitle: "Add Address") {
                        showAddressSheet = true
                    }
                } else {
                    ForEach(locationVM.savedAddresses) { addr in
                        AddressSelectionRow(address: addr, isSelected: selectedAddress?.id == addr.id) {
                            selectedAddress = addr
                            locationVM.selectAddress(addr)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                    }
                }

                Button {
                    showAddressSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill").foregroundColor(.primaryOrange)
                        Text("Add New Address")
                            .font(AppFont.labelMD).foregroundColor(.primaryOrange)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.primaryPastel)
                    .cornerRadius(AppRadius.lg)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
    }

    // MARK: Payment Step
    private var paymentStep: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                SectionHeader(title: "Payment Method")
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)

                VStack(spacing: 0) {
                    ForEach(PaymentMethod.allCases) { method in
                        PaymentMethodRow(method: method, isSelected: selectedPayment == method) {
                            selectedPayment = method
                        }
                        if method != PaymentMethod.allCases.last {
                            AppDivider().padding(.leading, 64)
                        }
                    }
                }
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
                .padding(.horizontal, AppSpacing.lg)

                SectionHeader(title: "Delivery Option")
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.sm)

                VStack(spacing: 0) {
                    ForEach(DeliveryOption.allCases) { option in
                        DeliveryOptionRow(option: option, isSelected: selectedDelivery == option) {
                            selectedDelivery = option
                        }
                        if option != DeliveryOption.allCases.last {
                            AppDivider().padding(.leading, 64)
                        }
                    }
                }
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
            }
        }
    }

    // MARK: Review Step
    private var reviewStep: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                // Items summary
                VStack(alignment: .leading, spacing: 0) {
                    Text("Order Items (\(cartVM.itemCount))")
                        .font(AppFont.labelLG).foregroundColor(.textPrimary)
                        .padding(AppSpacing.lg)
                    AppDivider()
                    ForEach(cartVM.items) { item in
                        HStack(spacing: AppSpacing.md) {
                            Image(systemName: item.product.primaryImage)
                                .font(.system(size: 24))
                                .foregroundColor(.primaryOrange.opacity(0.7))
                                .frame(width: 44, height: 44)
                                .background(Color.bgInput)
                                .cornerRadius(AppRadius.sm)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.product.name).font(AppFont.labelMD).lineLimit(1)
                                Text("Qty: \(item.quantity)").font(AppFont.caption).foregroundColor(.textSecondary)
                            }
                            Spacer()
                            Text("₹\(Int(item.totalPrice))").font(AppFont.labelMD)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.sm)
                    }
                }
                .background(Color.bgCard).cornerRadius(AppRadius.lg).cardShadow()
                .padding(.horizontal, AppSpacing.lg).padding(.top, AppSpacing.lg)

                // Address & Payment summary
                if let addr = selectedAddress {
                    CheckoutInfoRow(icon: "mappin.circle.fill", label: "Deliver to",
                                    value: "\(addr.displayCity), \(addr.displayArea)")
                        .padding(.horizontal, AppSpacing.lg)
                }
                CheckoutInfoRow(icon: selectedPayment.icon, label: "Payment",
                                value: selectedPayment.rawValue)
                    .padding(.horizontal, AppSpacing.lg)
                CheckoutInfoRow(icon: selectedDelivery.icon, label: "Delivery",
                                value: "\(selectedDelivery.rawValue) • \(selectedDelivery.estimatedDays)")
                    .padding(.horizontal, AppSpacing.lg)

                // Price breakdown
                VStack(spacing: 0) {
                    Text("Price Breakdown")
                        .font(AppFont.labelLG).foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(AppSpacing.lg)
                    AppDivider()
                    VStack(spacing: AppSpacing.md) {
                        PriceRow(label: "Subtotal", value: "₹\(Int(cartVM.subtotal))")
                        if cartVM.discount > 0 {
                            PriceRow(label: "Discount", value: "−₹\(Int(cartVM.discount))",
                                     valueColor: Color(hex: "#10B981") ?? .green)
                        }
                        PriceRow(label: "Tax (5%)", value: "₹\(Int(cartVM.tax))")
                        PriceRow(label: "Delivery", value: selectedDelivery.isFree ? "FREE" : "₹\(Int(selectedDelivery.charge))",
                                 valueColor: selectedDelivery.isFree ? (Color(hex: "#10B981") ?? .green) : .textPrimary)
                    }
                    .padding(.horizontal, AppSpacing.lg).padding(.vertical, AppSpacing.md)
                    AppDivider()
                    HStack {
                        Text("Total").font(AppFont.h4)
                        Spacer()
                        Text("₹\(Int(cartVM.total(deliveryCharge: selectedDelivery.charge)))")
                            .font(AppFont.priceLG)
                    }
                    .padding(AppSpacing.lg)
                }
                .background(Color.bgCard).cornerRadius(AppRadius.lg).cardShadow()
                .padding(.horizontal, AppSpacing.lg).padding(.bottom, AppSpacing.xl)
            }
        }
    }

    // MARK: Bottom Bar
    private var bottomBar: some View {
        HStack(spacing: AppSpacing.md) {
            if currentStep > 0 {
                Button("Back") {
                    withAnimation { currentStep -= 1 }
                } .font(AppFont.labelLG).foregroundColor(.primaryOrange)
                    .frame(width: 80).frame(height: 50)
                    .background(Color.primaryPastel).cornerRadius(AppRadius.lg)
            }

            if currentStep < 2 {
                AppButton(title: "Continue") {
                    withAnimation { currentStep += 1 }
                }
                .disabled(currentStep == 0 && selectedAddress == nil)
            } else {
                AppButton(title: "Place Order") { placeOrder() }
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .top)
    }

    private func placeOrder() {
        guard let address = selectedAddress,
              let userId = authVM.currentUser?.id else { return }
        let order = orderVM.placeOrder(
            items: cartVM.items,
            address: address,
            payment: selectedPayment,
            delivery: selectedDelivery,
            promoCode: cartVM.appliedPromo?.code,
            subtotal: cartVM.subtotal,
            discount: cartVM.discount,
            tax: cartVM.tax,
            userId: userId
        )
        cartVM.clearCart()
        placedOrder = order
        navigateToSuccess = true
    }
}

// MARK: - Supporting rows
private struct AddressSelectionRow: View {
    let address: Address
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: address.label.icon)
                    .foregroundColor(.primaryOrange)
                    .frame(width: 36, height: 36)
                    .background(Color.primaryPastel)
                    .cornerRadius(AppRadius.sm)
                VStack(alignment: .leading, spacing: 2) {
                    Text(address.label.rawValue.capitalized)
                        .font(AppFont.labelMD).foregroundColor(.textPrimary)
                    Text("\(address.displayCity), \(address.displayArea)")
                        .font(AppFont.bodySM).foregroundColor(.textSecondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .primaryOrange : .borderMedium)
            }
            .padding(AppSpacing.md)
            .background(Color.bgCard)
            .cornerRadius(AppRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .stroke(isSelected ? Color.primaryOrange : Color.borderLight, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: method.icon)
                    .foregroundColor(.primaryOrange)
                    .frame(width: 36, height: 36)
                    .background(Color.primaryPastel)
                    .cornerRadius(AppRadius.sm)
                VStack(alignment: .leading, spacing: 2) {
                    Text(method.rawValue).font(AppFont.labelMD).foregroundColor(.textPrimary)
                    Text(method.description).font(AppFont.caption).foregroundColor(.textSecondary)
                }
                Spacer()
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .primaryOrange : .borderMedium)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(.plain)
    }
}

private struct DeliveryOptionRow: View {
    let option: DeliveryOption
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: option.icon)
                    .foregroundColor(.primaryOrange)
                    .frame(width: 36, height: 36)
                    .background(Color.primaryPastel)
                    .cornerRadius(AppRadius.sm)
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.rawValue).font(AppFont.labelMD).foregroundColor(.textPrimary)
                    Text(option.estimatedDays).font(AppFont.caption).foregroundColor(.textSecondary)
                }
                Spacer()
                if option.isFree {
                    Text("FREE").font(AppFont.labelSM)
                        .foregroundColor(Color(hex: "#10B981") ?? .green)
                } else {
                    Text("₹\(Int(option.charge))").font(AppFont.labelMD).foregroundColor(.textPrimary)
                }
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isSelected ? .primaryOrange : .borderMedium)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(.plain)
    }
}

private struct CheckoutInfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .foregroundColor(.primaryOrange)
                .frame(width: 36, height: 36)
                .background(Color.primaryPastel)
                .cornerRadius(AppRadius.sm)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(AppFont.caption).foregroundColor(.textSecondary)
                Text(value).font(AppFont.labelMD).foregroundColor(.textPrimary).lineLimit(1)
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }
}
