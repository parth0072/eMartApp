import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel

    @State private var email          = ""
    @State private var password       = ""
    @State private var emailError:    String? = nil
    @State private var passwordError: String? = nil
    @State private var submitError    = ""
    @State private var isLoading      = false
    @State private var showRegister   = false

    private var canSubmit: Bool { !email.isEmpty && !password.isEmpty && !isLoading }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Two-tone background
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [Color.primaryOrange, Color.primaryDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 340)
                    Color.bgPrimary
                }
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // ── Hero ──────────────────────────────────────────
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 54, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.bottom, AppSpacing.xs)

                            Text("eMart")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)

                            Text("Shop Smart, Live Better")
                                .font(AppFont.bodyMD)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        .padding(.top, 72)
                        .padding(.bottom, AppSpacing.x3l)

                        // ── Form card ─────────────────────────────────────
                        VStack(alignment: .leading, spacing: AppSpacing.lg) {
                            // Heading
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Welcome Back! 👋")
                                    .font(AppFont.h2)
                                    .foregroundStyle(Color.textPrimary)
                                Text("Sign in to continue shopping")
                                    .font(AppFont.bodySM)
                                    .foregroundStyle(Color.textSecondary)
                            }

                            // Fields
                            VStack(spacing: AppSpacing.md) {
                                AppTextField(
                                    label: "Email Address",
                                    placeholder: "Enter your email",
                                    text: $email,
                                    leadingIcon: "envelope",
                                    keyboardType: .emailAddress,
                                    errorMessage: emailError
                                )
                                AppTextField(
                                    label: "Password",
                                    placeholder: "Enter your password",
                                    text: $password,
                                    leadingIcon: "lock",
                                    isSecure: true,
                                    errorMessage: passwordError
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

                            // Login button
                            AppButton(
                                title: "Login",
                                icon: "arrow.right",
                                iconTrailing: true,
                                size: .lg,
                                isLoading: isLoading,
                                isDisabled: !canSubmit
                            ) { login() }
                        }
                        .padding(AppSpacing.xl)
                        .background(Color.bgCard)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.xl))
                        .cardShadow()
                        .padding(.horizontal, AppSpacing.lg)

                        Spacer(minLength: AppSpacing.x4l)

                        // Register link
                        HStack(spacing: AppSpacing.xs) {
                            Text("Don't have an account?")
                                .font(AppFont.bodyMD)
                                .foregroundStyle(Color.textSecondary)
                            Button("Register now") { showRegister = true }
                                .font(AppFont.labelLG)
                                .foregroundStyle(Color.primaryOrange)
                        }
                        .padding(.bottom, AppSpacing.x3l)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }

    // MARK: - Validation
    private func validate() -> Bool {
        var valid = true
        emailError = nil; passwordError = nil; submitError = ""

        let trimEmail = email.trimmingCharacters(in: .whitespaces)
        if trimEmail.isEmpty {
            emailError = "Email is required"
            valid = false
        } else if !trimEmail.contains("@") || !trimEmail.contains(".") {
            emailError = "Enter a valid email address"
            valid = false
        }

        if password.isEmpty {
            passwordError = "Password is required"
            valid = false
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            valid = false
        }

        return valid
    }

    // MARK: - Login Action
    private func login() {
        guard validate() else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            do {
                try authVM.login(email: email, password: password)
            } catch {
                submitError = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
