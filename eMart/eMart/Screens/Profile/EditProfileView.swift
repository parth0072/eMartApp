import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isSaving = false
    @State private var saveError: String?
    @State private var saved = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xl) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(Color.primaryPastel)
                        .frame(width: 90, height: 90)
                    Text(initials)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.primaryOrange)
                }
                .padding(.top, AppSpacing.xl)

                // Form fields
                VStack(spacing: AppSpacing.md) {
                    AppTextField(label: "Full Name", placeholder: "Enter your full name",
                                 text: $fullName, leadingIcon: "person.fill")

                    AppTextField(label: "Email", placeholder: "Enter your email",
                                 text: $email, leadingIcon: "envelope.fill",
                                 keyboardType: .emailAddress)

                    AppTextField(label: "Phone", placeholder: "Enter your phone number",
                                 text: $phone, leadingIcon: "phone.fill",
                                 keyboardType: .phonePad)
                }
                .padding(.horizontal, AppSpacing.lg)

                if let error = saveError {
                    Text(error)
                        .font(AppFont.bodySM)
                        .foregroundColor(.error)
                        .padding(.horizontal, AppSpacing.lg)
                }

                AppButton(title: isSaving ? "Saving..." : "Save Changes") {
                    saveProfile()
                }
                .padding(.horizontal, AppSpacing.lg)
                .disabled(isSaving || !hasChanges)
                .opacity(hasChanges ? 1 : 0.6)

                Spacer()
            }
        }
        .background(Color.bgPrimary)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { prefillFields() }
        .overlay(savedOverlay)
    }

    // MARK: Saved Overlay
    @ViewBuilder
    private var savedOverlay: some View {
        if saved {
            VStack {
                Spacer()
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#10B981") ?? .green)
                    Text("Profile updated!")
                        .font(AppFont.labelMD)
                        .foregroundColor(.textPrimary)
                }
                .padding(.horizontal, AppSpacing.xl)
                .padding(.vertical, AppSpacing.md)
                .background(Color.bgCard)
                .cornerRadius(AppRadius.lg)
                .cardShadow()
                .padding(.bottom, AppSpacing.x3l)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    // MARK: Computed
    private var initials: String {
        let parts = fullName.split(separator: " ")
        let first = String(parts.first?.prefix(1) ?? "")
        let last  = parts.count > 1 ? String(parts.last?.prefix(1) ?? "") : ""
        return (first + last).uppercased().isEmpty ? "?" : (first + last).uppercased()
    }

    private var hasChanges: Bool {
        guard let user = authVM.currentUser else { return false }
        return fullName != user.fullName || email != user.email || phone != user.phone
    }

    // MARK: Methods
    private func prefillFields() {
        fullName = authVM.currentUser?.fullName ?? ""
        email    = authVM.currentUser?.email ?? ""
        phone    = authVM.currentUser?.phone ?? ""
    }

    private func saveProfile() {
        let trimmedName  = fullName.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)

        guard !trimmedName.isEmpty else { saveError = "Name cannot be empty"; return }
        guard trimmedEmail.contains("@") else { saveError = "Enter a valid email"; return }

        saveError = nil
        isSaving  = true

        authVM.updateProfile(fullName: trimmedName, email: trimmedEmail, phone: trimmedPhone)

        withAnimation { isSaving = false; saved = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { saved = false }
            dismiss()
        }
    }
}
