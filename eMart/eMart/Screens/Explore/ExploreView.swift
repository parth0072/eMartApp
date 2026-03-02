import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var storeVM: StoreViewModel

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    Text("Browse Categories")
                        .font(AppFont.h2)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)

                    LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                        ForEach(storeVM.categories) { category in
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                ExploreCategoryCard(category: category)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
            .background(Color.bgPrimary)
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.primaryOrange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

private struct ExploreCategoryCard: View {
    let category: ProductCategory

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(category.color.opacity(0.12))
                    .frame(height: 90)
                Image(systemName: category.icon)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(category.color)
            }

            Text(category.name)
                .font(AppFont.labelLG)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)

            Text("\(category.subcategories.count) subcategories")
                .font(AppFont.caption)
                .foregroundColor(.textTertiary)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity)
        .background(Color.bgCard)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }
}
