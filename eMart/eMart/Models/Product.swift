import Foundation
import SwiftUI

// MARK: - Category

struct ProductCategory: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var icon: String
    var colorHex: String
    var subcategories: [ProductSubcategory]

    var color: Color { Color(hex: colorHex) ?? .orange }
}

struct ProductSubcategory: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var categoryName: String
}

// MARK: - Product

struct Product: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var brand: String
    var description: String
    var category: String
    var subcategory: String
    var price: Double
    var originalPrice: Double
    var images: [String]          // SF Symbol names
    var rating: Double
    var reviewCount: Int
    var stock: Int
    var isFeatured: Bool = false
    var isNew: Bool = false
    var isBestSeller: Bool = false
    var colors: [String]?
    var sizes: [String]?
    var tags: [String] = []

    var discountPercent: Int {
        guard originalPrice > price else { return 0 }
        return Int(((originalPrice - price) / originalPrice) * 100)
    }
    var isOutOfStock: Bool { stock == 0 }
    var primaryImage: String { images.first ?? "photo" }
}

// MARK: - Review

struct Review: Identifiable, Codable {
    var id: UUID = UUID()
    var productId: UUID
    var userId: UUID
    var userName: String
    var rating: Int
    var title: String
    var body: String
    var date: Date
    var isVerified: Bool = true
}

// MARK: - PromoCode

struct PromoCode: Identifiable, Codable {
    var id: UUID = UUID()
    var code: String
    var discountPercent: Int
    var maxDiscount: Double
    var minOrder: Double
    var expiryDate: Date
    var isActive: Bool = true

    var isValid: Bool { isActive && expiryDate > Date() }
}

// MARK: - Sample Data

extension ProductCategory {
    static let samples: [ProductCategory] = [
        ProductCategory(name: "Electronics", icon: "iphone", colorHex: "#3B82F6",
            subcategories: [
                ProductSubcategory(name: "Smartphones", categoryName: "Electronics"),
                ProductSubcategory(name: "Laptops", categoryName: "Electronics"),
                ProductSubcategory(name: "Tablets", categoryName: "Electronics"),
                ProductSubcategory(name: "Audio", categoryName: "Electronics"),
                ProductSubcategory(name: "Cameras", categoryName: "Electronics"),
            ]),
        ProductCategory(name: "Fashion", icon: "tshirt.fill", colorHex: "#EC4899",
            subcategories: [
                ProductSubcategory(name: "Men's", categoryName: "Fashion"),
                ProductSubcategory(name: "Women's", categoryName: "Fashion"),
                ProductSubcategory(name: "Kids", categoryName: "Fashion"),
                ProductSubcategory(name: "Accessories", categoryName: "Fashion"),
            ]),
        ProductCategory(name: "Home & Living", icon: "house.fill", colorHex: "#10B981",
            subcategories: [
                ProductSubcategory(name: "Furniture", categoryName: "Home & Living"),
                ProductSubcategory(name: "Kitchen", categoryName: "Home & Living"),
                ProductSubcategory(name: "Decor", categoryName: "Home & Living"),
                ProductSubcategory(name: "Bedding", categoryName: "Home & Living"),
            ]),
        ProductCategory(name: "Beauty", icon: "sparkles", colorHex: "#8B5CF6",
            subcategories: [
                ProductSubcategory(name: "Skincare", categoryName: "Beauty"),
                ProductSubcategory(name: "Makeup", categoryName: "Beauty"),
                ProductSubcategory(name: "Haircare", categoryName: "Beauty"),
                ProductSubcategory(name: "Fragrances", categoryName: "Beauty"),
            ]),
        ProductCategory(name: "Sports", icon: "figure.run", colorHex: "#F59E0B",
            subcategories: [
                ProductSubcategory(name: "Equipment", categoryName: "Sports"),
                ProductSubcategory(name: "Clothing", categoryName: "Sports"),
                ProductSubcategory(name: "Footwear", categoryName: "Sports"),
                ProductSubcategory(name: "Outdoor", categoryName: "Sports"),
            ]),
        ProductCategory(name: "Books", icon: "book.fill", colorHex: "#EF4444",
            subcategories: [
                ProductSubcategory(name: "Fiction", categoryName: "Books"),
                ProductSubcategory(name: "Non-Fiction", categoryName: "Books"),
                ProductSubcategory(name: "Academic", categoryName: "Books"),
                ProductSubcategory(name: "Comics", categoryName: "Books"),
            ]),
        ProductCategory(name: "Toys", icon: "gamecontroller.fill", colorHex: "#06B6D4",
            subcategories: [
                ProductSubcategory(name: "Action Figures", categoryName: "Toys"),
                ProductSubcategory(name: "Board Games", categoryName: "Toys"),
                ProductSubcategory(name: "Outdoor Play", categoryName: "Toys"),
                ProductSubcategory(name: "Educational", categoryName: "Toys"),
            ]),
        ProductCategory(name: "Grocery", icon: "cart.fill", colorHex: "#84CC16",
            subcategories: [
                ProductSubcategory(name: "Fresh", categoryName: "Grocery"),
                ProductSubcategory(name: "Packaged", categoryName: "Grocery"),
                ProductSubcategory(name: "Beverages", categoryName: "Grocery"),
                ProductSubcategory(name: "Organic", categoryName: "Grocery"),
            ]),
    ]
}

extension PromoCode {
    static let samples: [PromoCode] = [
        PromoCode(code: "EMART10", discountPercent: 10, maxDiscount: 200, minOrder: 500,
                  expiryDate: Date().addingTimeInterval(30 * 24 * 3600)),
        PromoCode(code: "SAVE20", discountPercent: 20, maxDiscount: 500, minOrder: 1000,
                  expiryDate: Date().addingTimeInterval(15 * 24 * 3600)),
        PromoCode(code: "FIRST50", discountPercent: 50, maxDiscount: 300, minOrder: 300,
                  expiryDate: Date().addingTimeInterval(7 * 24 * 3600)),
        PromoCode(code: "WELCOME15", discountPercent: 15, maxDiscount: 250, minOrder: 400,
                  expiryDate: Date().addingTimeInterval(60 * 24 * 3600)),
    ]
}

extension Product {
    static let samples: [Product] = [
        // MARK: Electronics
        Product(name: "iPhone 15 Pro Max", brand: "Apple",
                description: "The most advanced iPhone with titanium design, A17 Pro chip, and a revolutionary camera system with 5x optical zoom. Features the always-on ProMotion display and USB-C connectivity.",
                category: "Electronics", subcategory: "Smartphones",
                price: 134900, originalPrice: 149900,
                images: ["iphone"], rating: 4.8, reviewCount: 2847, stock: 15,
                isFeatured: true, isNew: true,
                colors: ["Black Titanium", "White Titanium", "Natural Titanium", "Blue Titanium"],
                tags: ["5G", "ProCamera", "A17Pro"]),

        Product(name: "Samsung Galaxy S24 Ultra", brand: "Samsung",
                description: "Galaxy AI is here. Built-in S Pen for ultimate productivity. Titanium frame with 200MP camera and 5000mAh battery for all-day power.",
                category: "Electronics", subcategory: "Smartphones",
                price: 124999, originalPrice: 139999,
                images: ["iphone.gen1"], rating: 4.7, reviewCount: 1923, stock: 8,
                isFeatured: true,
                colors: ["Titanium Black", "Titanium Gray", "Titanium Violet"],
                tags: ["5G", "AI", "SPen"]),

        Product(name: "MacBook Pro 14\"", brand: "Apple",
                description: "Supercharged by M3 Pro chip with stunning Liquid Retina XDR display, all-day battery life, and the most powerful chip ever in a MacBook.",
                category: "Electronics", subcategory: "Laptops",
                price: 198900, originalPrice: 219900,
                images: ["laptopcomputer"], rating: 4.9, reviewCount: 1456, stock: 6,
                isFeatured: true, isNew: true,
                colors: ["Space Black", "Silver"],
                tags: ["M3", "Retina", "ProDisplay"]),

        Product(name: "Dell XPS 15", brand: "Dell",
                description: "Premium 15.6\" OLED display laptop with Intel Core i9, 32GB RAM, and dedicated RTX 4070. The professional's choice for performance.",
                category: "Electronics", subcategory: "Laptops",
                price: 169990, originalPrice: 189990,
                images: ["laptopcomputer"], rating: 4.6, reviewCount: 834, stock: 10,
                colors: ["Platinum Silver"],
                tags: ["OLED", "RTX4070", "i9"]),

        Product(name: "Sony WH-1000XM5", brand: "Sony",
                description: "Industry-leading noise canceling with Auto NC Optimizer. 30-hour battery life with quick charge. Crystal clear calls with AI-enhanced microphones.",
                category: "Electronics", subcategory: "Audio",
                price: 26990, originalPrice: 34990,
                images: ["headphones"], rating: 4.6, reviewCount: 3241, stock: 25,
                isBestSeller: true,
                colors: ["Midnight Black", "Platinum Silver"],
                tags: ["NoiseCancel", "Wireless", "HiRes"]),

        Product(name: "iPad Pro 12.9\"", brand: "Apple",
                description: "The ultimate iPad experience with M2 chip, Liquid Retina XDR display, and Apple Pencil hover. Perfect for creative professionals.",
                category: "Electronics", subcategory: "Tablets",
                price: 112900, originalPrice: 124900,
                images: ["ipad"], rating: 4.8, reviewCount: 987, stock: 12,
                colors: ["Space Gray", "Silver"]),

        Product(name: "Canon EOS R50", brand: "Canon",
                description: "Compact mirrorless camera with 24.2MP APS-C sensor, 4K 30p video, and intelligent auto features. Perfect for content creators.",
                category: "Electronics", subcategory: "Cameras",
                price: 54990, originalPrice: 64990,
                images: ["camera"], rating: 4.5, reviewCount: 612, stock: 9,
                isNew: true, colors: ["Black", "White"]),

        // MARK: Fashion
        Product(name: "Premium Cotton T-Shirt", brand: "H&M",
                description: "Ultra-soft 100% organic cotton t-shirt with a relaxed fit. Breathable, durable, and perfect for everyday wear.",
                category: "Fashion", subcategory: "Men's",
                price: 799, originalPrice: 1299,
                images: ["tshirt.fill"], rating: 4.2, reviewCount: 567, stock: 100,
                colors: ["White", "Black", "Navy", "Gray", "Red"],
                sizes: ["XS", "S", "M", "L", "XL", "XXL"]),

        Product(name: "Levi's 511 Slim Jeans", brand: "Levi's",
                description: "Streamlined, narrow fit through the seat and thighs. Made with stretch denim for all-day comfort. The iconic slim silhouette.",
                category: "Fashion", subcategory: "Men's",
                price: 2999, originalPrice: 4499,
                images: ["rectangle.fill"], rating: 4.5, reviewCount: 892, stock: 60,
                isBestSeller: true,
                colors: ["Indigo", "Black", "Gray"],
                sizes: ["28", "30", "32", "34", "36"]),

        Product(name: "Floral Wrap Dress", brand: "Zara",
                description: "Beautiful floral wrap dress with V-neckline and adjustable tie waist. Lightweight fabric perfect for any occasion.",
                category: "Fashion", subcategory: "Women's",
                price: 2499, originalPrice: 3999,
                images: ["figure.dress.line.vertical.figure"], rating: 4.4, reviewCount: 423, stock: 45,
                isNew: true,
                colors: ["Blue Floral", "Pink Floral", "Red Floral"],
                sizes: ["XS", "S", "M", "L"]),

        Product(name: "Nike Air Max 270", brand: "Nike",
                description: "Max Air cushioning unit delivers lightweight, big-time cushioning for all-day comfort. Breathable mesh upper with bold style.",
                category: "Fashion", subcategory: "Footwear",
                price: 10999, originalPrice: 13995,
                images: ["shoe.fill"], rating: 4.6, reviewCount: 1247, stock: 35,
                isBestSeller: true,
                colors: ["Black/White", "White/Red", "Triple Black"],
                sizes: ["6", "7", "8", "9", "10", "11"]),

        Product(name: "Ray-Ban Aviator Classic", brand: "Ray-Ban",
                description: "The iconic metal frame with UV protection crystal lenses. Timeless aviator shape that never goes out of style.",
                category: "Fashion", subcategory: "Accessories",
                price: 7500, originalPrice: 9500,
                images: ["eyeglasses"], rating: 4.7, reviewCount: 756, stock: 20,
                colors: ["Gold/Green", "Silver/Blue", "Gold/Brown"]),

        // MARK: Home & Living
        Product(name: "Instant Pot Duo 7-in-1", brand: "Instant Pot",
                description: "7-in-1 multi-use programmable pressure cooker, slow cooker, rice cooker, steamer, sauté, yogurt maker and warmer. 6 quart capacity.",
                category: "Home & Living", subcategory: "Kitchen",
                price: 7999, originalPrice: 12999,
                images: ["cooktop"], rating: 4.8, reviewCount: 2341, stock: 30,
                isFeatured: true, isBestSeller: true),

        Product(name: "Minimalist Floor Lamp", brand: "IKEA",
                description: "Sleek minimalist floor lamp with adjustable arm and warm LED bulb. Energy efficient and perfect for reading nooks or living rooms.",
                category: "Home & Living", subcategory: "Decor",
                price: 3499, originalPrice: 4999,
                images: ["lamp.floor.fill"], rating: 4.3, reviewCount: 328, stock: 18,
                colors: ["White", "Black", "Brass"]),

        Product(name: "Egyptian Cotton Bedsheet Set", brand: "Spaces",
                description: "400 thread count 100% Egyptian cotton bedsheet set. Includes 1 flat sheet, 1 fitted sheet, and 2 pillow covers. Luxuriously soft.",
                category: "Home & Living", subcategory: "Bedding",
                price: 3299, originalPrice: 5499,
                images: ["bed.double.fill"], rating: 4.5, reviewCount: 445, stock: 40,
                colors: ["White", "Ivory", "Sage Blue", "Dusty Rose"]),

        // MARK: Beauty
        Product(name: "Vitamin C Brightening Serum", brand: "The Ordinary",
                description: "15% L-Ascorbic Acid serum that visibly brightens skin tone and reduces dark spots. Lightweight formula for daily use.",
                category: "Beauty", subcategory: "Skincare",
                price: 899, originalPrice: 1299,
                images: ["drop.fill"], rating: 4.4, reviewCount: 1892, stock: 75,
                isFeatured: true),

        Product(name: "Matte Lipstick Collection", brand: "MAC",
                description: "Long-lasting matte lipstick with rich pigment and comfortable wear. Highly pigmented with 6 iconic shades that flatter every skin tone.",
                category: "Beauty", subcategory: "Makeup",
                price: 1699, originalPrice: 1999,
                images: ["paintbrush.fill"], rating: 4.6, reviewCount: 934, stock: 50,
                colors: ["Ruby Woo", "Velvet Teddy", "Whirl", "Diva", "Lady Danger", "Rebel"]),

        Product(name: "Argan Oil Repair Hair Mask", brand: "L'Oréal",
                description: "Intensive repair hair mask enriched with pure Argan Oil. Restores shine and softness to dry, damaged, and color-treated hair.",
                category: "Beauty", subcategory: "Haircare",
                price: 699, originalPrice: 999,
                images: ["wand.and.stars"], rating: 4.3, reviewCount: 567, stock: 65),

        // MARK: Sports
        Product(name: "Pro Yoga Mat 6mm", brand: "Manduka",
                description: "Eco-friendly non-slip yoga mat with superior grip surface. 6mm thickness for excellent joint protection. Includes carrying strap.",
                category: "Sports", subcategory: "Equipment",
                price: 3299, originalPrice: 4999,
                images: ["figure.yoga"], rating: 4.7, reviewCount: 789, stock: 28,
                colors: ["Indigo Purple", "Ocean Blue", "Onyx Black", "Forest Green"]),

        Product(name: "Adidas Ultraboost 23", brand: "Adidas",
                description: "Responsive Boost midsole returns energy with every stride. Primeknit+ upper adapts to your foot. Built for performance running.",
                category: "Sports", subcategory: "Footwear",
                price: 12999, originalPrice: 17999,
                images: ["figure.run"], rating: 4.8, reviewCount: 1456, stock: 22,
                isFeatured: true, isBestSeller: true,
                colors: ["Core Black", "Cloud White", "Legend Ink"],
                sizes: ["6", "7", "8", "9", "10", "11"]),

        Product(name: "Resistance Bands Set (5 Pack)", brand: "TRX",
                description: "Set of 5 resistance bands with varying resistance levels (5-50 lbs). Perfect for strength training, rehab, and home workouts.",
                category: "Sports", subcategory: "Equipment",
                price: 1499, originalPrice: 2499,
                images: ["figure.strengthtraining.traditional"], rating: 4.5, reviewCount: 612, stock: 55),

        // MARK: Books
        Product(name: "Atomic Habits", brand: "Clear Press",
                description: "No. 1 New York Times bestseller. An easy and proven way to build good habits and break bad ones by James Clear.",
                category: "Books", subcategory: "Non-Fiction",
                price: 399, originalPrice: 599,
                images: ["book.fill"], rating: 4.9, reviewCount: 4521, stock: 200,
                isBestSeller: true),

        Product(name: "The Midnight Library", brand: "Canongate",
                description: "A dazzling novel about all the choices that go into a life well lived. By Matt Haig — international bestseller.",
                category: "Books", subcategory: "Fiction",
                price: 299, originalPrice: 499,
                images: ["books.vertical.fill"], rating: 4.6, reviewCount: 2134, stock: 150),

        // MARK: Grocery
        Product(name: "Organic Green Tea (50 bags)", brand: "Twinings",
                description: "Premium organic green tea. Light, refreshing taste rich in natural antioxidants. Sustainably sourced leaves.",
                category: "Grocery", subcategory: "Beverages",
                price: 399, originalPrice: 549,
                images: ["cup.and.saucer.fill"], rating: 4.4, reviewCount: 234, stock: 120,
                isNew: true),

        Product(name: "Premium Mixed Nuts 500g", brand: "Happilo",
                description: "Premium dry fruit mix with California almonds, cashews, walnuts, and pistachios. No added salt, no preservatives.",
                category: "Grocery", subcategory: "Packaged",
                price: 699, originalPrice: 899,
                images: ["leaf.fill"], rating: 4.5, reviewCount: 412, stock: 80),

        // MARK: Toys
        Product(name: "LEGO Technic Bugatti Chiron", brand: "LEGO",
                description: "Build the iconic Bugatti Chiron with 3,599 pieces. Features authentic details including 8-speed gearbox, W16 engine, and moveable wing.",
                category: "Toys", subcategory: "Educational",
                price: 18999, originalPrice: 23999,
                images: ["gamecontroller.fill"], rating: 4.9, reviewCount: 892, stock: 15,
                isFeatured: true),
    ]
}

extension Review {
    static func samples(for productId: UUID) -> [Review] {
        [
            Review(productId: productId, userId: UUID(),
                   userName: "Rahul M.", rating: 5,
                   title: "Absolutely love it!", body: "Exceeded my expectations. Build quality is top notch and performance is blazing fast. Highly recommend!", date: Date().addingTimeInterval(-2 * 24 * 3600)),
            Review(productId: productId, userId: UUID(),
                   userName: "Priya S.", rating: 4,
                   title: "Great product, minor issue", body: "The product itself is fantastic. Delivery was also fast. Docked one star for the packaging — could be better.", date: Date().addingTimeInterval(-5 * 24 * 3600)),
            Review(productId: productId, userId: UUID(),
                   userName: "Arjun K.", rating: 5,
                   title: "Worth every rupee", body: "Used it for 2 weeks now and it's perfect. The quality is exactly as described. Would definitely buy again.", date: Date().addingTimeInterval(-10 * 24 * 3600)),
            Review(productId: productId, userId: UUID(),
                   userName: "Sneha R.", rating: 4,
                   title: "Good buy", body: "Nice product at this price point. Delivery was on time and product matches the description.", date: Date().addingTimeInterval(-15 * 24 * 3600)),
        ]
    }
}
