import Foundation
import Combine

class OrderViewModel: ObservableObject {

    @Published var orders: [Order] = []
    private let ordersKey = "emart_orders"

    init() { loadOrders() }

    // MARK: - Place Order

    func placeOrder(
        items: [CartItem],
        address: Address,
        payment: PaymentMethod,
        delivery: DeliveryOption,
        promoCode: String?,
        subtotal: Double,
        discount: Double,
        tax: Double,
        userId: UUID
    ) -> Order {
        let deliveryCharge = delivery.charge
        let total = max(subtotal - discount, 0) + tax + deliveryCharge
        let deliveryDays: Int = {
            switch delivery {
            case .standard:  return Int.random(in: 3...5)
            case .express:   return Int.random(in: 1...2)
            case .overnight: return 1
            }
        }()

        let order = Order(
            orderNumber: Order.generateOrderNumber(),
            userId: userId,
            items: items.map {
                OrderItem(product: $0.product, quantity: $0.quantity,
                          price: $0.product.price,
                          selectedColor: $0.selectedColor,
                          selectedSize: $0.selectedSize)
            },
            deliveryAddress: address,
            paymentMethod: payment,
            deliveryOption: delivery,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            deliveryCharge: deliveryCharge,
            total: total,
            status: .placed,
            placedDate: Date(),
            estimatedDelivery: Calendar.current.date(byAdding: .day, value: deliveryDays, to: Date()) ?? Date(),
            promoCode: promoCode
        )

        orders.insert(order, at: 0)
        saveOrders()
        return order
    }

    // MARK: - Queries

    func orders(for userId: UUID) -> [Order] {
        orders.filter { $0.userId == userId }
    }

    func order(by id: UUID) -> Order? {
        orders.first { $0.id == id }
    }

    // MARK: - Persistence

    private func saveOrders() {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: ordersKey)
        }
    }

    private func loadOrders() {
        guard let data = UserDefaults.standard.data(forKey: ordersKey),
              let decoded = try? JSONDecoder().decode([Order].self, from: data) else { return }
        orders = decoded
    }
}
