import SwiftUI

@main
struct eMarApp: App {
    @StateObject private var authVM     = AuthViewModel()
    @StateObject private var locationVM = LocationViewModel()
    @StateObject private var storeVM    = StoreViewModel()
    @StateObject private var cartVM     = CartViewModel()
    @StateObject private var orderVM    = OrderViewModel()

    @State private var showSplash = true
    @AppStorage("emart_hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    showSplash = false
                                }
                            }
                        }
                } else if !hasSeenOnboarding {
                    OnboardingView()
                } else if authVM.isAuthenticated {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authVM)
            .environmentObject(locationVM)
            .environmentObject(storeVM)
            .environmentObject(cartVM)
            .environmentObject(orderVM)
            .animation(.easeInOut(duration: 0.35), value: authVM.isAuthenticated)
            .animation(.easeInOut(duration: 0.35), value: hasSeenOnboarding)
        }
    }
}
