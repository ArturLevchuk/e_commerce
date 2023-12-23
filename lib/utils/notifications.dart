import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/constants.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> createCartNotification(int itemsCount) async {
  await AwesomeNotifications()
      .cancelNotificationsByChannelKey(cartNotificationKey);
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: cartNotificationKey,
      title: 'You have pending purchases!!!',
      body: "There are $itemsCount items in your cart. Don't wait, order!",
      category: NotificationCategory.Recommendation,
    ),
    schedule: NotificationInterval(interval: 60, repeats: false),
  );
}

Future<void> cancelNotificationsByChannelKey(String channelKey) {
  return AwesomeNotifications()
      .cancelNotificationsByChannelKey(cartNotificationKey);
}
