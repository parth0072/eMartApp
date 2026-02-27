import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    // ── Header banner ──────────────────────────────────────
                    ZStack(alignment: .bottom) {
                        LinearGradient(
                            colors: [Color.primaryOrange, Color.primaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 160)

                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color.bgCard)
                                .frame(width: 86, height: 86)
                                .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)

                            Text(authVM.currentUser?.initials ?? "?")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.primaryOrange)
                        }
                        .offset(y: 43)
                    }

                    // ── User info ──────────────────────────────────────────
                    VStack(spacing: AppSpacing.xs) {
                        Text(authVM.currentUser?.fullName ?? "")
                            .font(AppFont.h2)
                            .foregroundStyle(Color.textPrimary)

                        Text(authVM.currentUser?.email ?? "")
                            .font(AppFont.bodyMD)
                            .foregroundStyle(Color.textSecondary)
                    }
                    .padding(.top, 54)
                    .padding(.bottom, AppSpacing.xl)

                    // ── Stats row ──────────────────────────────────────────
                    HStack(spacing: 0) {
                        ProfileStat(value: "12", label: "Orders")
                        Divider().frame(height: 36)
                        ProfileStat(value: "4", label: "Wishlist")
                        Divider().frame(height: 36)
                        ProfileStat(value: "2", label: "Reviews")
                    }
                    .padding(.vertical, AppSpacing.lg)
                    .background(Color.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                    .cardShadow()
                    .padding(.horizontal, AppSpacing.lg)

                    // ── Account section ────────────────────────────────────
                    ProfileSection(title: "Account") {
                        ProfileRow(icon: "person.fill",     label: "Personal Info",       color: Color.primaryOrange)
                        ProfileRow(icon: "phone.fill",      label: authVM.currentUser?.phone ?? "", color: Color.info, isSubtitle: true)
                        ProfileRow(icon: "location.fill",   label: "Saved Addresses",     color: Color.success)
                        ProfileRow(icon: "creditcard.fill", label: "Payment Methods",     color: Color.warning)
                    }

                    // ── Orders section ─────────────────────────────────────
                    ProfileSection(title: "Shopping") {
                        ProfileRow(icon: "bag.fill",       label: "My Orders",           color: Color.primaryOrange)
                        ProfileRow(icon: "heart.fill",     label: "Wishlist",            color: Color.error)
                        ProfileRow(icon: "star.fill",      label: "My Reviews",          color: Color.ratingYellow)
                        ProfileRow(icon: "tag.fill",       label: "Coupons & Offers",    color: Color.success)
                    }

                    // ── Support section ────────────────────────────────────
                    ProfileSection(title: "Help & Settings") {
                        ProfileRow(icon: "bell.fill",              label: "Notifications",        color: Color.info)
                        ProfileRow(icon: "questionmark.circle.fill", label: "Help & Support",     color: Color.primaryOrange)
                        ProfileRow(icon: "doc.text.fill",          label: "Terms & Privacy",      color: Color.textSecondary)
                    }

                    // ── Logout ─────────────────────────────────────────────
                    Button {
                        authVM.logout()
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Log Out")
                                .font(AppFont.labelLG)
                        }
                        .foregroundStyle(Color.error)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.lg)
                        .background(Color.errorLight)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                        .cardShadow()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.sm)

                    // Member since
                    if let joined = authVM.currentUser?.joinedDate {
                        Text("Member since \(joined.formatted(.dateTime.month(.wide).year()))")
                            .font(AppFont.caption)
                            .foregroundStyle(Color.textTertiary)
                            .padding(.top, AppSpacing.lg)
                    }

                    Spacer(minLength: 100)
                }
            }
            .background(Color.bgPrimary)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primaryOrange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Sub-components

private struct ProfileStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(value)
                .font(AppFont.h2)
                .foregroundStyle(Color.primaryOrange)
            Text(label)
                .font(AppFont.bodySM)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ProfileSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(AppFont.labelMD)
                .foregroundStyle(Color.textTertiary)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.top, AppSpacing.xl)
                .padding(.bottom, AppSpacing.sm)

            VStack(spacing: 0) {
                content
            }
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}

private struct ProfileRow: View {
    let icon: String
    let label: String
    let color: Color
    var isSubtitle: Bool = false

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(color)
            }

            Text(label)
                .font(isSubtitle ? AppFont.bodyMD : AppFont.labelLG)
                .foregroundStyle(isSubtitle ? Color.textSecondary : Color.textPrimary)

            Spacer()

            if !isSubtitle {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .contentShape(Rectangle())
        .overlay(alignment: .bottom) {
            Divider()
                .padding(.leading, 56 + AppSpacing.lg)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
