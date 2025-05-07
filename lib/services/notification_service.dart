import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  
  // Inicializar serviço de notificações
  Future<void> initialize() async {
    // Solicitar permissão para notificações
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Configurar notificações locais
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(initializationSettings);

      // Configurar handlers para mensagens FCM
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Obter token FCM
      String? token = await _fcm.getToken();
      print('FCM Token: $token'); // TODO: Salvar token no Firestore
    }
  }

  // Handler para mensagens em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Mensagem recebida em foreground: ${message.messageId}');
    await _showLocalNotification(message);
  }

  // Handler para mensagens em background
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Aplicativo aberto a partir da notificação: ${message.messageId}');
    // Implementar navegação ou ação específica aqui
  }

  // Handler para mensagens quando o app está fechado
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Mensagem recebida em background: ${message.messageId}');
  }

  // Mostrar notificação local
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'Notificações Importantes',
      channelDescription: 'Canal para notificações importantes',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Nova Notificação',
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data['route'],
    );
  }

  // Enviar notificação para tópico específico
  Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(topic);
  }

  // Cancelar inscrição em tópico
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  // Limpar todas as notificações
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}