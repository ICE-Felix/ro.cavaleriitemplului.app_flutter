import 'dart:async';
import 'package:app/core/navigation/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  // Stream to listen to messages
  static Stream<RemoteMessage> get messageStream =>
      _messageStreamController.stream;

  /// Initialize FCM
  static Future<void> initialize() async {
    // Request permission for iOS
    await requestPermission();

    // Get the token
    String? token = await getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
      // TODO: Send this token to your server
    }

    // Configure foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');
      debugPrint('Received foreground message: ${message.notification?.body}');
      _messageStreamController.add(message);
    });

    // Handle message tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message tapped: ${message.notification?.title}');
      _handleMessageTap(message);
    });

    // Check if app was launched from a terminated state by tapping notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        'App launched from notification: ${initialMessage.notification?.title}',
      );
      _handleMessageTap(initialMessage);
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      // TODO: Send new token to your server
    });
  }

  /// Request notification permission (iOS specific)
  static Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Permission granted: ${settings.authorizationStatus}');
  }

  /// Get FCM token
  static Future<String?> getToken() async {
    try {
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Handle message tap navigation
  static void _handleMessageTap(RemoteMessage message) {
    if (message.data.containsKey('route')) {
      String route = message.data['route'];
      dynamic extra = message.data['extra'];
      routes.go(route, extra: extra);
      // Navigate to specific route
      debugPrint('Navigate to: $route');
    }
  }

  /// Dispose resources
  static void dispose() {
    _messageStreamController.close();
  }
}
