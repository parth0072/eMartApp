import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search products..."
    var onSubmit: (() -> Void)? = nil
    var onFilter: (() -> Void)? = nil
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            // Search field
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isFocused ? Color.primaryOrange : Color.textTertiary)

                TextField(placeholder, text: $text)
                    .font(AppFont.bodyMD)
                    .foregroundStyle(Color.textPrimary)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit { onSubmit?() }

                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.textTertiary)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .frame(height: 46)
            .background(Color.bgInput)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(isFocused ? Color.primaryOrange : Color.clear, lineWidth: 1.5)
            )

            // Filter button (optional)
            if let onFilter {
                Button(action: onFilter) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.white)
                        .frame(width: 46, height: 46)
                        .background(
                            LinearGradient(colors: [.primaryOrange, .primaryDark],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Search Suggestion Row
struct SearchSuggestionRow: View {
    let text: String
    var isRecent: Bool = true
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isRecent ? "clock" : "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.textTertiary)
                    .frame(width: 20)

                Text(text)
                    .font(AppFont.bodyMD)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        SearchBar(text: .constant(""), onFilter: {})
        SearchBar(text: .constant("iPhone case"), onFilter: {})
        SearchBar(text: .constant(""))

        VStack(spacing: 0) {
            SearchSuggestionRow(text: "Nike running shoes", isRecent: true) {}
            Divider().padding(.leading, 52)
            SearchSuggestionRow(text: "Wireless headphones", isRecent: false) {}
        }
        .background(Color.bgCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    }
    .padding()
    .background(Color.bgPrimary)
}
