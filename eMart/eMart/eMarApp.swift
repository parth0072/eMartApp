import SwiftUI

@main
struct eMarApp: App {
    @StateObject private var authVM     = AuthViewModel()
    @StateObject private var locationVM = LocationViewModel()

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
            .environmentObject(locationVM)
            .animation(.easeInOut(duration: 0.35), value: authVM.isAuthenticated)
        }
    }
}
