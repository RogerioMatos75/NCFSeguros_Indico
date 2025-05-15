import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(initializationSettings);

      // Configurar handlers para mensagens FCM
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Obter token FCM e salvar no Firestore
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }

      // Atualizar token quando for renovado
      _onTokenRefresh();
    }
  }

  // Handler para mensagens em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Mensagem recebida em foreground: ${message.messageId}');
    await _showLocalNotification(message);
  }

  // Handler para mensagens em background
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint(
        'Aplicativo aberto a partir da notificação: ${message.messageId}');
    // Implementar navegação ou ação específica aqui
  }

  // Handler para mensagens quando o app está fechado
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Mensagem recebida em background: ${message.messageId}');
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

  Future<void> notify(String title, String body,
      {String? payload, int id = 0}) async {
    try {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.max,
        priority: Priority.high,
      );

      const platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _localNotifications.show(id, title, body, platformChannelSpecifics,
          payload: payload);
      debugPrint('Notificação local mostrada: $id');
    } catch (e) {
      debugPrint('Erro ao mostrar notificação: $e');
    }
  }

  Future<void> showSuccess(String message, {String title = 'Sucesso!'}) async {
    try {
      await notify(title, message);
      debugPrint('Notificação de sucesso: $title - $message');
    } catch (e) {
      debugPrint('Erro ao mostrar notificação de sucesso: $e');
    }
  }

  Future<void> showError(String message, {String title = 'Erro!'}) async {
    try {
      await notify(title, message);
      debugPrint('Notificação de erro: $title - $message');
    } catch (e) {
      debugPrint('Erro ao mostrar notificação de erro: $e');
    }
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

  // Salvar token FCM no Firestore
  Future<void> _saveTokenToFirestore(String token) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
      debugPrint('Token FCM atualizado com sucesso');
    }
  }

  void _onTokenRefresh() {
    _fcm.onTokenRefresh.listen((token) {
      debugPrint('Novo token FCM: $token');
      if (_auth.currentUser != null) {
        _saveTokenToFirestore(token);
      }
    });
  }
}
