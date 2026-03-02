import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @AppStorage("emart_darkMode")      private var darkMode      = false
    @AppStorage("emart_notifications") private var notifications = true

    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

    var body: some View {
        List {
            // Preferences
            Section("Preferences") {
                SettingsToggleRow(icon: "moon.fill", iconColor: Color(hex: "#8B5CF6") ?? .purple,
                                  title: "Dark Mode", value: $darkMode)
                SettingsToggleRow(icon: "bell.fill", iconColor: Color(hex: "#3B82F6") ?? .blue,
                                  title: "Push Notifications", value: $notifications)
            }

            // App
            Section("App") {
                SettingsLinkRow(icon: "star.fill", iconColor: Color(hex: "#F59E0B") ?? .yellow,
                                title: "Rate eMart") {
                    // Open App Store rating (no-op in simulator)
                }
                SettingsLinkRow(icon: "square.and.arrow.up.fill", iconColor: Color(hex: "#10B981") ?? .green,
                                title: "Share App") {
                    shareApp()
                }
            }

            // Legal
            Section("Legal") {
                SettingsLinkRow(icon: "lock.shield.fill", iconColor: Color(hex: "#6366F1") ?? .indigo,
                                title: "Privacy Policy") {}
                SettingsLinkRow(icon: "doc.text.fill", iconColor: Color.textSecondary,
                                title: "Terms of Service") {}
            }

            // About
            Section("About") {
                HStack {
                    SettingsIconBox(icon: "info.circle.fill", color: Color.primaryOrange)
                    Text("Version")
                        .font(AppFont.labelMD)
                    Spacer()
                    Text(appVersion)
                        .font(AppFont.bodyMD)
                        .foregroundColor(.textSecondary)
                }
                .padding(.vertical, 4)
            }

            // Danger zone
            Section {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    HStack {
                        SettingsIconBox(icon: "person.badge.minus.fill", color: Color.error)
                        Text("Delete Account")
                            .font(AppFont.labelMD)
                            .foregroundColor(.error)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .background(Color.bgPrimary)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Delete Account", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) { authVM.logout() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
    }

    private func shareApp() {
        let text = "Check out eMart — the smartest way to shop!"
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            root.present(av, animated: true)
        }
    }
}

// MARK: - Reusable rows

private struct SettingsIconBox: View {
    let icon: String
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 32, height: 32)
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

private struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var value: Bool

    var body: some View {
        HStack {
            SettingsIconBox(icon: icon, color: iconColor)
            Toggle(title, isOn: $value)
                .font(AppFont.labelMD)
        }
        .padding(.vertical, 4)
    }
}

private struct SettingsLinkRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                SettingsIconBox(icon: icon, color: iconColor)
                Text(title)
                    .font(AppFont.labelMD)
                    .foregroundColor(.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.textTertiary)
            }
            .padding(.vertical, 4)
        }
    }
}
