import SwiftUI

// MARK: - App Text Field
struct AppTextField: View {
    let label: String
    var placeholder: String = ""
    @Binding var text: String
    var leadingIcon: String? = nil
    var trailingIcon: String? = nil
    var onTrailingTap: (() -> Void)? = nil
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var errorMessage: String? = nil
    var isDisabled: Bool = false

    @FocusState private var isFocused: Bool
    @State private var isSecureVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Label
            Text(label)
                .font(AppFont.labelMD)
                .foregroundStyle(Color.textSecondary)

            // Field
            HStack(spacing: AppSpacing.sm) {
                if let leadingIcon {
                    Image(systemName: leadingIcon)
                        .font(.system(size: 16))
                        .foregroundStyle(isFocused ? Color.primaryOrange : Color.textTertiary)
                        .frame(width: 20)
                }

                Group {
                    if isSecure && !isSecureVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                    }
                }
                .font(AppFont.bodyMD)
                .foregroundStyle(Color.textPrimary)
                .focused($isFocused)
                .disabled(isDisabled)

                if isSecure {
                    Button {
                        isSecureVisible.toggle()
                    } label: {
                        Image(systemName: isSecureVisible ? "eye.slash" : "eye")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.textTertiary)
                    }
                } else if let trailingIcon {
                    Button(action: { onTrailingTap?() }) {
                        Image(systemName: trailingIcon)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(height: 52)
            .background(isDisabled ? Color.bgInput.opacity(0.5) : Color.bgInput)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(
                        errorMessage != nil ? Color.error :
                        isFocused ? Color.primaryOrange : Color.clear,
                        lineWidth: 1.5
                    )
            )

            // Error
            if let err = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                    Text(err)
                        .font(AppFont.bodySM)
                }
                .foregroundStyle(Color.error)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Quantity Stepper
struct QuantityStepper: View {
    @Binding var quantity: Int
    var min: Int = 1
    var max: Int = 99

    var body: some View {
        HStack(spacing: 0) {
            Button {
                if quantity > min { quantity -= 1 }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(quantity <= min ? Color.textTertiary : Color.primaryOrange)
                    .frame(width: 40, height: 40)
            }
            .disabled(quantity <= min)

            Text("\(quantity)")
                .font(AppFont.h4)
                .foregroundStyle(Color.textPrimary)
                .frame(width: 44, height: 40)
                .multilineTextAlignment(.center)

            Button {
                if quantity < max { quantity += 1 }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(quantity >= max ? Color.textTertiary : Color.primaryOrange)
                    .frame(width: 40, height: 40)
            }
            .disabled(quantity >= max)
        }
        .background(Color.bgInput)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.sm)
                .stroke(Color.borderLight, lineWidth: 1)
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        AppTextField(label: "Email", placeholder: "you@example.com",
                     text: .constant(""), leadingIcon: "envelope")
        AppTextField(label: "Password", placeholder: "Enter password",
                     text: .constant("secret"), isSecure: true)
        AppTextField(label: "Search", placeholder: "Search...",
                     text: .constant("Nike"), leadingIcon: "magnifyingglass",
                     trailingIcon: "xmark.circle.fill")
        AppTextField(label: "Disabled", placeholder: "Not editable",
                     text: .constant(""), isDisabled: true)
        AppTextField(label: "Error", placeholder: "Enter email",
                     text: .constant("bad"), leadingIcon: "envelope",
                     errorMessage: "Please enter a valid email")

        HStack {
            Text("Quantity")
                .font(AppFont.labelLG)
            Spacer()
            QuantityStepper(quantity: .constant(2))
        }
        .padding()
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
    .padding()
    .background(Color.bgPrimary)
}
