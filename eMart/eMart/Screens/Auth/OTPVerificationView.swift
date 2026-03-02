import SwiftUI

struct OTPVerificationView: View {
    let email: String
    @Environment(\.dismiss) private var dismiss

    @State private var otpDigits = ["", "", "", ""]
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordError = ""
    @State private var isVerified = false
    @State private var isLoading = false
    @State private var resendTimer = 60
    @State private var canResend = false
    @State private var showSuccess = false
    @FocusState private var focusedField: Int?

    // Mock OTP
    private let mockOTP = "1234"

    var enteredOTP: String { otpDigits.joined() }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea()

            if showSuccess {
                successView
            } else {
                ScrollView {
                    VStack(spacing: AppSpacing.x3l) {
                        // Header
                        VStack(spacing: AppSpacing.lg) {
                            ZStack {
                                Circle()
                                    .fill(Color.primaryPastel)
                                    .frame(width: 100, height: 100)
                                Image(systemName: isVerified ? "lock.open.fill" : "message.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(.primaryOrange)
                            }
                            .padding(.top, AppSpacing.x3l)

                            VStack(spacing: AppSpacing.sm) {
                                Text(isVerified ? "Set New Password" : "Verify OTP")
                                    .font(AppFont.h1)
                                    .foregroundColor(.textPrimary)
                                Text(isVerified
                                     ? "Create a strong new password for your account."
                                     : "Enter the 4-digit code sent to\n\(email)")
                                    .font(AppFont.bodyMD)
                                    .foregroundColor(.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                            }
                        }
                        .padding(.horizontal, AppSpacing.xl)

                        if !isVerified {
                            otpInputSection
                        } else {
                            passwordSection
                        }
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { startTimer(); focusedField = 0 }
    }

    // MARK: OTP Input
    private var otpInputSection: some View {
        VStack(spacing: AppSpacing.xl) {
            // OTP boxes
            HStack(spacing: AppSpacing.lg) {
                ForEach(0..<4, id: \.self) { i in
                    OTPBox(digit: $otpDigits[i], isFocused: focusedField == i) {
                        focusedField = i
                    }
                    .focused($focusedField, equals: i)
                    .onChange(of: otpDigits[i]) { val in
                        if val.count > 1 { otpDigits[i] = String(val.last!) }
                        if !val.isEmpty && i < 3 { focusedField = i + 1 }
                    }
                }
            }

            // Hint
            Text("Hint: use 1234")
                .font(AppFont.caption)
                .foregroundColor(.textTertiary)

            // Verify button
            AppButton(title: isLoading ? "" : "Verify OTP",
                      isLoading: isLoading,
                      isDisabled: enteredOTP.count < 4) {
                verifyOTP()
            }
            .padding(.horizontal, AppSpacing.xl)

            // Resend
            HStack(spacing: 4) {
                Text("Didn't receive it?")
                    .font(AppFont.bodySM)
                    .foregroundColor(.textSecondary)
                if canResend {
                    Button("Resend OTP") { resendOTP() }
                        .font(AppFont.labelMD)
                        .foregroundColor(.primaryOrange)
                } else {
                    Text("Resend in \(resendTimer)s")
                        .font(AppFont.labelMD)
                        .foregroundColor(.textTertiary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.xl)
    }

    // MARK: Password Section
    private var passwordSection: some View {
        VStack(spacing: AppSpacing.lg) {
            AppTextField(
                label: "New Password",
                placeholder: "Min. 6 characters",
                text: $newPassword,
                leadingIcon: "lock.fill",
                isSecure: true
            )
            AppTextField(
                label: "Confirm Password",
                placeholder: "Re-enter new password",
                text: $confirmPassword,
                leadingIcon: "lock.fill",
                isSecure: true,
                errorMessage: passwordError.isEmpty ? nil : passwordError
            )

            AppButton(title: isLoading ? "" : "Update Password",
                      isLoading: isLoading,
                      isDisabled: newPassword.count < 6 || confirmPassword.isEmpty) {
                updatePassword()
            }
        }
        .padding(.horizontal, AppSpacing.xl)
    }

    // MARK: Success
    private var successView: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            ZStack {
                Circle().fill(Color(hex: "#ECFDF5") ?? .green.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(hex: "#10B981") ?? .green)
            }
            Text("Password Updated!")
                .font(AppFont.h1).foregroundColor(.textPrimary)
            Text("Your password has been reset successfully. You can now login with your new password.")
                .font(AppFont.bodyMD).foregroundColor(.textSecondary)
                .multilineTextAlignment(.center).lineSpacing(4)
                .padding(.horizontal, AppSpacing.xl)
            Spacer()
            AppButton(title: "Back to Login") {
                // Pop to root (login)
                dismiss()
                dismiss()
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.bottom, AppSpacing.x4l)
        }
    }

    // MARK: Actions
    private func verifyOTP() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
            if enteredOTP == mockOTP {
                withAnimation { isVerified = true }
            } else {
                otpDigits = ["", "", "", ""]
                focusedField = 0
            }
        }
    }

    private func updatePassword() {
        passwordError = ""
        guard newPassword.count >= 6 else { passwordError = "Minimum 6 characters"; return }
        guard newPassword == confirmPassword else { passwordError = "Passwords do not match"; return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            withAnimation { showSuccess = true }
        }
    }

    private func startTimer() {
        resendTimer = 60
        canResend = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if resendTimer > 0 { resendTimer -= 1 }
            else { canResend = true; t.invalidate() }
        }
    }

    private func resendOTP() { startTimer() }
}

// MARK: - OTP Box
private struct OTPBox: View {
    @Binding var digit: String
    let isFocused: Bool
    let onTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppRadius.md)
                .strokeBorder(isFocused ? Color.primaryOrange : Color.borderMedium, lineWidth: isFocused ? 2 : 1)
                .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(Color.bgCard))
                .frame(width: 64, height: 64)

            if digit.isEmpty {
                Text("—").font(AppFont.h2).foregroundColor(.borderMedium)
            } else {
                Text(digit).font(AppFont.h1).foregroundColor(.textPrimary)
            }

            TextField("", text: $digit)
                .keyboardType(.numberPad)
                .frame(width: 64, height: 64)
                .opacity(0.011)
        }
        .onTapGesture(perform: onTap)
    }
}
