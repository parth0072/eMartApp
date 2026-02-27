import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var fullName: String
    var email: String
    var phone: String
    var joinedDate: Date

    var initials: String {
        let parts = fullName.split(separator: " ")
        let first = String(parts.first?.prefix(1) ?? "")
        let last  = parts.count > 1 ? String(parts.last?.prefix(1) ?? "") : ""
        return (first + last).uppercased()
    }

    var firstName: String {
        String(fullName.split(separator: " ").first ?? Substring(fullName))
    }
}
