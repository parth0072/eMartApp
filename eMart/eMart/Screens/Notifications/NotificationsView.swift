import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var storeVM: StoreViewModel

    var body: some View {
        Group {
            if storeVM.notifications.isEmpty {
                EmptyStateView(
                    icon: "bell.slash",
                    title: "No notifications",
                    message: "You're all caught up! We'll notify you about orders and deals."
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                notificationList
            }
        }
        .background(Color.bgPrimary)
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.primaryOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            if storeVM.unreadCount > 0 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mark all read") {
                        storeVM.markAllRead()
                    }
                    .font(AppFont.labelSM)
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            storeVM.markAllRead()
        }
    }

    private var notificationList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.sm) {
                ForEach(storeVM.notifications) { notification in
                    NotificationRow(notification: notification)
                        .onTapGesture {
                            storeVM.markRead(notification.id)
                        }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
    }
}

// MARK: - Notification Row

private struct NotificationRow: View {
    let notification: AppNotification

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Icon bubble
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill((Color(hex: notification.type.colorHex) ?? .orange).opacity(0.12))
                    .frame(width: 46, height: 46)
                Image(systemName: notification.type.icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: notification.type.colorHex) ?? .orange)
            }

            // Content
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(notification.title)
                    .font(notification.isRead ? AppFont.labelMD : AppFont.labelLG)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)

                Text(notification.body)
                    .font(AppFont.bodySM)
                    .foregroundColor(.textSecondary)
                    .lineLimit(2)

                Text(notification.timeAgo)
                    .font(AppFont.caption)
                    .foregroundColor(.textTertiary)
                    .padding(.top, 2)
            }

            Spacer()

            // Unread dot
            if !notification.isRead {
                Circle()
                    .fill(Color.primaryOrange)
                    .frame(width: 8, height: 8)
                    .padding(.top, 4)
            }
        }
        .padding(AppSpacing.md)
        .background(notification.isRead ? Color.bgCard : Color.primaryPastel)
        .cornerRadius(AppRadius.lg)
        .cardShadow()
    }
}
