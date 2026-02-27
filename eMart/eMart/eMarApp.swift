import SwiftUI

@main
struct eMarApp: App {
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isAuthenticated {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authVM)
            .animation(.easeInOut(duration: 0.35), value: authVM.isAuthenticated)
        }
    }
}
