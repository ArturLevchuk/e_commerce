abstract interface class NotificationService {
  Future<void> init();

  Future<String> createNotification({
    required String title,
    required String body,
    String? channelKey,
    required Duration timeOut,
  });

  Future<void> cancelNotification({required String id});

  Future<void> cancelNotificationsByChannelKey({required String channelKey});

  Future<void> cancelAllNotifications();

  Future<bool> isNotificationAllowed();

  Future<void> requestNotificationPermission();
}
