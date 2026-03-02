import SwiftUI

struct OrdersView: View {
    @EnvironmentObject var orderVM: OrderViewModel
    @EnvironmentObject var authVM: AuthViewModel

    @State private var selectedFilter: OrderFilter = .all

    enum OrderFilter: String, CaseIterable {
        case all       = "All"
        case active    = "Active"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
    }

    private var filteredOrders: [Order] {
        let userOrders = orderVM.orders(for: authVM.currentUser?.id ?? UUID())
        switch selectedFilter {
        case .all:       return userOrders
        case .active:    return userOrders.filter { $0.status.isActive }
        case .delivered: return userOrders.filter { $0.status == .delivered }
        case .cancelled: return userOrders.filter { $0.status == .cancelled }
        }
    }

    var body: some View {
        Group {
            if filteredOrders.isEmpty && selectedFilter == .all {
                emptyState
            } else {
                orderList
            }
        }
        .background(Color.bgPrimary)
        .navigationTitle("My Orders")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: Empty State
    private var emptyState: some View {
        EmptyStateView(
            icon: "bag",
            title: "No orders yet",
            message: "Your orders will appear here once you shop."
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Order List
    private var orderList: some View {
        VStack(spacing: 0) {
            // Filter tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(OrderFilter.allCases, id: \.self) { filter in
                        CategoryChip(
                            title: filter.rawValue,
                            isSelected: selectedFilter == filter
                        ) {
                            withAnimation { selectedFilter = filter }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)
            }
            .background(Color.bgCard)
            .overlay(Divider(), alignment: .bottom)

            if filteredOrders.isEmpty {
                EmptyStateView(
                    icon: "tray",
                    title: "No \(selectedFilter.rawValue.lowercased()) orders"
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        ForEach(filteredOrders) { order in
                            NavigationLink(destination: OrderDetailView(order: order)) {
                                OrderRow(order: order)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
    }
}

// MARK: - Order Row
private struct OrderRow: View {
    let order: Order

    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text("#\(order.orderNumber)")
                        .font(AppFont.labelLG)
                        .foregroundColor(.textPrimary)
                    Text(order.placedDate.formatted(.dateTime.day().month(.wide).year()))
                        .font(AppFont.caption)
                        .foregroundColor(.textSecondary)
                }
                Spacer()
                StatusBadge(status: order.status)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.md)

            AppDivider()

            // Items preview
            HStack(spacing: AppSpacing.sm) {
                // Up to 3 item icons
                HStack(spacing: AppSpacing.xs) {
                    ForEach(Array(order.items.prefix(3)), id: \.id) { item in
                        ZStack {
                            RoundedRectangle(cornerRadius: AppRadius.xs)
                                .fill(Color.bgInput)
                                .frame(width: 44, height: 44)
                            Image(systemName: item.product.primaryImage)
                                .font(.system(size: 18))
                                .foregroundColor(.primaryOrange.opacity(0.7))
                        }
                    }
                    if order.items.count > 3 {
                        Text("+\(order.items.count - 3)")
                            .font(AppFont.labelSM)
                            .foregroundColor(.textSecondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("₹\(Int(order.total))")
                        .font(AppFont.priceSM)
                        .foregroundColor(.textPrimary)
                    Text("\(order.items.count) item\(order.items.count == 1 ? "" : "s")")
                        .font(AppFont.caption)
                        .foregroundColor(.textSecondary)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)

            // Estimated delivery
            if order.status.isActive {
                AppDivider()
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.primaryOrange)
                    Text("Estimated by \(order.estimatedDelivery.formatted(.dateTime.day().month(.abbreviated)))")
                        .font(AppFont.caption)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.textTertiary)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.sm)
            }
        }
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .cardShadow()
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let status: OrderStatus

    var body: some View {
        Text(status.rawValue)
            .font(AppFont.labelSM)
            .foregroundColor(Color(hex: status.colorHex) ?? .orange)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 4)
            .background((Color(hex: status.colorHex) ?? .orange).opacity(0.12))
            .clipShape(Capsule())
    }
}
