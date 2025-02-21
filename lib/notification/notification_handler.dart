import 'package:auscurator/api_service_myconcept/keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

class NotificationHandler {
  String? status;
  Map? payload;
  RemoteMessage? remoteMessage;
  NotificationHandler();

  NotificationHandler.handle({this.remoteMessage}) {
    // if (remoteMessage == null || remoteMessage?.data.isEmpty == true) return;
    if (remoteMessage == null) return;
    Map data = remoteMessage?.data ?? {};
    if (data.isEmpty) return;
    logger.e(data);
    // String payloadData = jsonEncode(remoteMessage?.data);
    NotificationService.showSimpleNotification(
      title: data['title'] ?? '',
      body: data['description'] ?? '',
    );
  }

  NotificationHandler.handleTap() {
    openScreen();
  }

  void openScreen() {
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (ctx) => const BottomNavScreen()),
    //     (route) => false,
    //   );
    // Get.to(const NotificationScreen());
  }
}
