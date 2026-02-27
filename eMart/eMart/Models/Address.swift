import Foundation

struct Address: Identifiable, Codable, Equatable {
    let id: UUID
    var label: AddressLabel
    var city: String
    var area: String
    var pincode: String
    var latitude: Double?
    var longitude: Double?

    enum AddressLabel: String, Codable, CaseIterable {
        case home  = "Home"
        case work  = "Work"
        case other = "Other"

        var icon: String {
            switch self {
            case .home:  return "house.fill"
            case .work:  return "briefcase.fill"
            case .other: return "location.fill"
            }
        }
    }

    // Display helpers
    var displayCity: String { city.isEmpty ? "Select Location" : city }

    var displayArea: String {
        [area, pincode].filter { !$0.isEmpty }.joined(separator: ", ")
    }
}
