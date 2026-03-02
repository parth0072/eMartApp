import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var emailError = ""
    @State private var isLoading = false
    @State private var otpSent = false
    @State private var navigateToOTP = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bgPrimary.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: AppSpacing.x3l) {
                        // Header illustration
                        VStack(spacing: AppSpacing.lg) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryPastel)
                                    .frame(width: 100, height: 100)
                                Image(systemName: "lock.rotation")
                                    .font(.system(size: 44, weight: .medium))
                                    .foregroundColor(.primaryOrange)
                            }
                            .padding(.top, AppSpacing.x3l)

                            VStack(spacing: AppSpacing.sm) {
                                Text("Forgot Password?")
                                    .font(AppFont.h1)
                                    .foregroundColor(.textPrimary)
                                Text("Enter your registered email and we'll send an OTP to reset your password.")
                                    .font(AppFont.bodyMD)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, AppSpacing.xl)

                        // Form
                        VStack(spacing: AppSpacing.lg) {
                            AppTextField(
                                label: "Email Address",
                                placeholder: "you@example.com",
                                text: $email,
                                leadingIcon: "envelope.fill",
                                keyboardType: .emailAddress,
                                errorMessage: emailError.isEmpty ? nil : emailError
                            )

                            NavigationLink(destination: OTPVerificationView(email: email), isActive: $navigateToOTP) {
                                EmptyView()
                            }

                            AppButton(title: isLoading ? "" : "Send OTP", isLoading: isLoading,
                                      isDisabled: email.isEmpty) {
                                sendOTP()
                            }
                        }
                        .padding(.horizontal, AppSpacing.xl)
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textPrimary)
                    }
                }
            }
        }
    }

    private func sendOTP() {
        emailError = ""
        guard email.contains("@") && email.contains(".") else {
            emailError = "Please enter a valid email address"
            return
        }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isLoading = false
            navigateToOTP = true
        }
    }
}
