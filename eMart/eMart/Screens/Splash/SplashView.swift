import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0
    @State private var taglineOpacity: Double = 0

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.primaryOrange, Color.primaryDark],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: AppSpacing.lg) {
                // Logo mark
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 110, height: 110)
                    Circle()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 85, height: 85)
                    Image(systemName: "cart.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)

                // Word mark
                HStack(spacing: 0) {
                    Text("e")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white.opacity(0.85))
                    Text("Mart")
                        .font(.system(size: 42, weight: .black))
                        .foregroundColor(.white)
                }
                .opacity(opacity)

                Text("Shop Smarter, Live Better")
                    .font(AppFont.bodyMD)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(taglineOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.5)) {
                taglineOpacity = 1.0
            }
        }
    }
}
