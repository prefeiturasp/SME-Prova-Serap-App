import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificacaoPushService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? topico = "1";

  static Future _backgroundHandler(RemoteMessage message) async {
    print(message);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print(message);
  }

  static Future inicializarApp() async {
    await Firebase.initializeApp();
    messaging.subscribeToTopic(topico!);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
  }
}
