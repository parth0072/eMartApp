import SwiftUI

// MARK: - Persistence model
private struct StoredUser: Codable {
    var password: String
    var user: User
}

// MARK: - UserDefaults keys
private enum UDKey {
    static let users    = "emart_users"
    static let loggedIn = "emart_loggedIn_email"
}

// MARK: - AuthViewModel
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User? = nil

    enum AuthError: LocalizedError {
        case invalidCredentials
        case emailAlreadyExists

        var errorDescription: String? {
            switch self {
            case .invalidCredentials: return "Invalid email or password. Please try again."
            case .emailAlreadyExists: return "An account with this email already exists."
            }
        }
    }

    private var store: [String: StoredUser] = [:]

    init() {
        loadStore()
        restoreSession()
    }

    // MARK: - Public API

    func login(email: String, password: String) throws {
        let key = normalized(email)
        guard let record = store[key], record.password == password else {
            throw AuthError.invalidCredentials
        }
        UserDefaults.standard.set(key, forKey: UDKey.loggedIn)
        withAnimation(.easeInOut(duration: 0.3)) {
            currentUser = record.user
            isAuthenticated = true
        }
    }

    func register(fullName: String, email: String, phone: String, password: String) throws {
        let key = normalized(email)
        guard store[key] == nil else { throw AuthError.emailAlreadyExists }
        let user = User(
            id: UUID(),
            fullName: fullName,
            email: email.trimmingCharacters(in: .whitespaces),
            phone: phone.trimmingCharacters(in: .whitespaces),
            joinedDate: Date()
        )
        store[key] = StoredUser(password: password, user: user)
        saveStore()
        UserDefaults.standard.set(key, forKey: UDKey.loggedIn)
        withAnimation(.easeInOut(duration: 0.3)) {
            currentUser = user
            isAuthenticated = true
        }
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: UDKey.loggedIn)
        withAnimation(.easeInOut(duration: 0.3)) {
            currentUser = nil
            isAuthenticated = false
        }
    }

    // MARK: - Persistence

    private func loadStore() {
        guard
            let data = UserDefaults.standard.data(forKey: UDKey.users),
            let decoded = try? JSONDecoder().decode([String: StoredUser].self, from: data)
        else { return }
        store = decoded
    }

    private func saveStore() {
        guard let data = try? JSONEncoder().encode(store) else { return }
        UserDefaults.standard.set(data, forKey: UDKey.users)
    }

    private func restoreSession() {
        guard
            let email = UserDefaults.standard.string(forKey: UDKey.loggedIn),
            let record = store[email]
        else { return }
        currentUser = record.user
        isAuthenticated = true
    }

    private func normalized(_ email: String) -> String {
        email.lowercased().trimmingCharacters(in: .whitespaces)
    }
}
