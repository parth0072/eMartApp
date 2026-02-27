import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var fullName       = ""
    @State private var email          = ""
    @State private var phone          = ""
    @State private var password       = ""
    @State private var confirmPassword = ""

    @State private var nameError:    String? = nil
    @State private var emailError:   String? = nil
    @State private var phoneError:   String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmError: String? = nil
    @State private var submitError   = ""
    @State private var isLoading     = false

    private var canSubmit: Bool {
        !fullName.isEmpty && !email.isEmpty && !phone.isEmpty &&
        !password.isEmpty && !confirmPassword.isEmpty && !isLoading
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Two-tone background
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.primaryOrange, Color.primaryDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 240)
                Color.bgPrimary
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // ── Header ────────────────────────────────────────────
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.xxl)

                    VStack(spacing: AppSpacing.xs) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 38, weight: .semibold))
                            .foregroundStyle(.white)
                        Text("Create Account")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        Text("Join eMart and start shopping")
                            .font(AppFont.bodySM)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    .padding(.top, AppSpacing.sm)
                    .padding(.bottom, AppSpacing.x3l)

                    // ── Form card ─────────────────────────────────────────
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        // Personal details section
                        Text("Personal Details")
                            .font(AppFont.h3)
                            .foregroundStyle(Color.textPrimary)

                        VStack(spacing: AppSpacing.md) {
                            AppTextField(
                                label: "Full Name",
                                placeholder: "Enter your full name",
                                text: $fullName,
                                leadingIcon: "person",
                                errorMessage: nameError
                            )
                            AppTextField(
                                label: "Email Address",
                                placeholder: "Enter your email",
                                text: $email,
                                leadingIcon: "envelope",
                                keyboardType: .emailAddress,
                                errorMessage: emailError
                            )
                            AppTextField(
                                label: "Phone Number",
                                placeholder: "Enter your phone number",
                                text: $phone,
                                leadingIcon: "phone",
                                keyboardType: .phonePad,
                                errorMessage: phoneError
                            )
                        }

                        Divider()
                            .padding(.vertical, AppSpacing.xs)

                        // Password section
                        Text("Set Password")
                            .font(AppFont.h3)
                            .foregroundStyle(Color.textPrimary)

                        VStack(spacing: AppSpacing.md) {
                            AppTextField(
                                label: "Password",
                                placeholder: "Min. 6 characters",
                                text: $password,
                                leadingIcon: "lock",
                                isSecure: true,
                                errorMessage: passwordError
                            )
                            AppTextField(
                                label: "Confirm Password",
                                placeholder: "Re-enter your password",
                                text: $confirmPassword,
                                leadingIcon: "lock.shield",
                                isSecure: true,
                                errorMessage: confirmError
                            )
                        }

                        // Submit error banner
                        if !submitError.isEmpty {
                            HStack(spacing: AppSpacing.xs) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .font(.system(size: 14))
                                Text(submitError)
                                    .font(AppFont.bodySM)
                            }
                            .foregroundStyle(Color.error)
                            .padding(AppSpacing.sm)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.errorLight)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
                        }

                        // Register button
                        AppButton(
                            title: "Create Account",
                            icon: "checkmark",
                            iconTrailing: true,
                            size: .lg,
                            isLoading: isLoading,
                            isDisabled: !canSubmit
                        ) { register() }
                    }
                    .padding(AppSpacing.xl)
                    .background(Color.bgCard)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
                    .cardShadow()
                    .padding(.horizontal, AppSpacing.lg)

                    Spacer(minLength: AppSpacing.x4l)

                    // Login link
                    HStack(spacing: AppSpacing.xs) {
                        Text("Already have an account?")
                            .font(AppFont.bodyMD)
                            .foregroundStyle(Color.textSecondary)
                        Button("Login") { dismiss() }
                            .font(AppFont.labelLG)
                            .foregroundStyle(Color.primaryOrange)
                    }
                    .padding(.bottom, AppSpacing.x3l)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Validation
    private func validate() -> Bool {
        var valid = true
        nameError = nil; emailError = nil; phoneError = nil
        passwordError = nil; confirmError = nil; submitError = ""

        let trimName = fullName.trimmingCharacters(in: .whitespaces)
        if trimName.count < 2 {
            nameError = "Please enter your full name"
            valid = false
        }

        let trimEmail = email.trimmingCharacters(in: .whitespaces)
        if trimEmail.isEmpty {
            emailError = "Email is required"
            valid = false
        } else if !trimEmail.contains("@") || !trimEmail.contains(".") {
            emailError = "Enter a valid email address"
            valid = false
        }

        let digits = phone.filter { $0.isNumber }
        if digits.count < 10 {
            phoneError = "Enter a valid phone number (min. 10 digits)"
            valid = false
        }

        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            valid = false
        }

        if confirmPassword != password {
            confirmError = "Passwords do not match"
            valid = false
        }

        return valid
    }

    // MARK: - Register Action
    private func register() {
        guard validate() else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            do {
                try authVM.register(
                    fullName: fullName.trimmingCharacters(in: .whitespaces),
                    email: email.trimmingCharacters(in: .whitespaces),
                    phone: phone.trimmingCharacters(in: .whitespaces),
                    password: password
                )
            } catch {
                submitError = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(AuthViewModel())
}
