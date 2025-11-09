import 'dart:async';
import 'package:app/core/navigation/routes.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/core/services/supabase_fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  // Keep track of subscriptions for cleanup
  StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  StreamSubscription<RemoteMessage>? _messageOpenedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;

  bool _isInitialized = false;
  String? _currentToken;

  // Stream to listen to messages
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  // Getter for current token
  String? get currentToken => _currentToken;

  // Check if service is initialized
  bool get isInitialized => _isInitialized;

  String? currentUserId;

  /// Initialize FCM service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('Firebase Messaging Service already initialized');
      return;
    }

    try {
      debugPrint('Initializing Firebase Messaging Service...');

      // Request permission for iOS
      await _requestPermission();

      // Setup message listeners
      await _setupMessageListeners();

      // Handle initial message if app was launched from notification
      await _handleInitialMessage();

      _isInitialized = true;
      debugPrint('Firebase Messaging Service initialized successfully');

      // Subscribe to the "all" topic for broadcast notifications
      await subscribeToTopic('all');
    } catch (e) {
      debugPrint('Error initializing Firebase Messaging Service: $e');
      rethrow;
    }
  }

  Future<void> clearAuthData() async {
    currentUserId = null;
    _currentToken = null;
  }

  /// Close and cleanup all resources
  Future<void> close() async {
    if (!_isInitialized) {
      debugPrint('Firebase Messaging Service not initialized');
      return;
    }
    currentUserId = null;

    try {
      debugPrint('Closing Firebase Messaging Service...');

      // Cancel all subscriptions
      await _foregroundMessageSubscription?.cancel();
      await _messageOpenedAppSubscription?.cancel();
      await _tokenRefreshSubscription?.cancel();

      // Close stream controller
      if (!_messageStreamController.isClosed) {
        await _messageStreamController.close();
      }

      // Reset state
      _foregroundMessageSubscription = null;
      _messageOpenedAppSubscription = null;
      _tokenRefreshSubscription = null;
      _currentToken = null;
      _isInitialized = false;

      debugPrint('Firebase Messaging Service closed successfully');
    } catch (e) {
      debugPrint('Error closing Firebase Messaging Service: $e');
    }
  }

  Future<void> refreshToken() async {
    await initializeTokenForLoggedUser(userId: currentUserId);
  }

  /// Request notification permission (iOS specific)
  Future<NotificationSettings> _requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _messaging.getAPNSToken();
      }

      debugPrint('Notification permission: ${settings.authorizationStatus}');
      return settings;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      rethrow;
    }
  }

  /// Initialize and get FCM token
  Future<void> initializeTokenForLoggedUser({required String? userId}) async {
    if (currentUserId == null && userId == null) {
      throw Exception('User ID not found for initializeTokenForLoggedUser');
    }

    try {
      _currentToken = await _messaging.getToken();
      if (_currentToken != null) {
        debugPrint('FCM Token obtained: $_currentToken');
        currentUserId = userId;
        await _sendTokenToServer(token: _currentToken!);
      } else {
        debugPrint('Failed to get FCM token');
      }
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  /// Setup all message listeners
  Future<void> _setupMessageListeners() async {
    try {
      // Listen for messages when app is in foreground
      _foregroundMessageSubscription = FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
          if (kDebugMode) {
            debugPrint(
              'Received foreground message: ${message.notification?.title}',
            );
            debugPrint('Message body: ${message.notification?.body}');
            debugPrint('Message data: ${message.data}');
          }

          // Add message to stream for listeners
          if (!_messageStreamController.isClosed) {
            _messageStreamController.add(message);
          }
        },
        onError: (error) {
          debugPrint('Error in foreground message listener: $error');
        },
      );

      // Listen for messages when app is opened from notification
      _messageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp
          .listen(
            (RemoteMessage message) {
              if (kDebugMode) {
                debugPrint(
                  'App opened from notification: ${message.notification?.title}',
                );
              }
              // Handle message tap
              _handleMessageTap(message);
            },
            onError: (error) {
              debugPrint('Error in message opened app listener: $error');
            },
          );

      // Listen for token refresh
      _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
          .listen(
            (newToken) {
              if (kDebugMode) {
                debugPrint('FCM Token refreshed: $newToken');
              }
              _currentToken = newToken;
              if (currentUserId != null) {
                _sendTokenToServer(token: newToken);
              }
            },
            onError: (error) {
              debugPrint('Error in token refresh listener: $error');
            },
          );

      if (kDebugMode) {
        debugPrint('Message listeners setup completed');
      }
    } catch (e) {
      debugPrint('Error setting up message listeners: $e');
      rethrow;
    }
  }

  /// Handle initial message if app was launched from notification
  Future<void> _handleInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          'App launched from notification: ${initialMessage.notification?.title}',
        );
        // Add a small delay to ensure app is fully initialized
        await Future.delayed(const Duration(milliseconds: 500));
        _handleMessageTap(initialMessage);
      }
    } catch (e) {
      debugPrint('Error handling initial message: $e');
    }
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    if (!_isInitialized) {
      debugPrint('Service not initialized. Call initialize() first.');
      return null;
    }

    try {
      if (_currentToken != null) {
        return _currentToken;
      }

      _currentToken = await _messaging.getToken();
      return _currentToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Send token to server (implement based on your backend)
  Future<void> _sendTokenToServer({required String token}) async {
    if (currentUserId == null) {
      debugPrint('User ID not found');
      return;
    }

    try {
      final userDeviceModel = await sl<SupabaseFcmService>()
          .createDeviceRegistration(userId: currentUserId!, fcmToken: token);
      await sl<SupabaseFcmService>().registerDevice(userDeviceModel);
    } catch (e) {
      debugPrint('Error sending token to server: $e');
    }
  }

  /// Subscribe to a topic
  Future<bool> subscribeToTopic(String topic) async {
    if (!_isInitialized) {
      debugPrint('Service not initialized. Call initialize() first.');
      return false;
    }

    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Successfully subscribed to topic: $topic');
      return true;
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
      return false;
    }
  }

  /// Unsubscribe from a topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    if (!_isInitialized) {
      debugPrint('Service not initialized. Call initialize() first.');
      return false;
    }

    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Successfully unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
      return false;
    }
  }

  /// Subscribe to multiple topics
  Future<Map<String, bool>> subscribeToTopics(List<String> topics) async {
    final results = <String, bool>{};

    for (final topic in topics) {
      results[topic] = await subscribeToTopic(topic);
    }

    return results;
  }

  /// Unsubscribe from multiple topics
  Future<Map<String, bool>> unsubscribeFromTopics(List<String> topics) async {
    final results = <String, bool>{};

    for (final topic in topics) {
      results[topic] = await unsubscribeFromTopic(topic);
    }

    return results;
  }

  /// Handle message tap navigation
  void _handleMessageTap(RemoteMessage message) {
    try {
      debugPrint('Handling message tap: ${message.data}');

      if (message.data.containsKey('route')) {
        String route = message.data['route'];
        dynamic extra =
            message.data.containsKey('extra') ? message.data['extra'] : null;

        debugPrint('Navigating to route: $route with extra: $extra');
        routes.go(route, extra: extra);
      } else {
        // Default navigation or action when no specific route is provided
        debugPrint(
          'No route specified in message data, using default behavior',
        );
        _handleDefaultNavigation(message);
      }
    } catch (e) {
      debugPrint('Error handling message tap: $e');
    }
  }

  /// Handle default navigation when no specific route is provided
  void _handleDefaultNavigation(RemoteMessage message) {
    try {
      // Implement default behavior based on your app's needs
      // Example: navigate to notifications page or home
      debugPrint(
        'Executing default navigation for message: ${message.notification?.title}',
      );

      // You can implement custom logic here based on message type or data
      // routes.go('/notifications');
    } catch (e) {
      debugPrint('Error in default navigation: $e');
    }
  }

  /// Clear all delivered notifications
  Future<void> clearAllNotifications() async {
    try {
      // This will clear all delivered notifications from the notification center
      // Note: This is platform specific and may not work on all platforms
      debugPrint('Clearing all notifications');
      // Implementation depends on your notification plugin
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }

  /// Get delivery reports or analytics
  Map<String, dynamic> getServiceStatus() {
    return {
      'isInitialized': _isInitialized,
      'hasToken': _currentToken != null,
      'token': _currentToken,
      'hasActiveListeners':
          _foregroundMessageSubscription != null &&
          _messageOpenedAppSubscription != null &&
          _tokenRefreshSubscription != null,
      'streamControllerClosed': _messageStreamController.isClosed,
    };
  }
}
