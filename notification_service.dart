// lib/providers/notification_service.dart

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/constants/app_constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'ten_sports_hd_channel',
    'TEN SPORTS HD Notifications',
    description: 'Match alerts and breaking news',
    importance: Importance.high,
    enableVibration: true,
    playSound: true,
  );

  Future<void> initialize() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Local notifications setup
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotif.initialize(initSettings);

    // Create channel
    await _localNotif
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // FCM foreground
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Subscribe to topics
    await _subscribeToTopics();

    // FCM token
    final token = await _fcm.getToken();
    debugPrint('FCM Token: $token');
  }

  Future<void> _subscribeToTopics() async {
    await _fcm.subscribeToTopic(AppConstants.topicAll);
    await _fcm.subscribeToTopic(AppConstants.topicMatchAlerts);
    await _fcm.subscribeToTopic(AppConstants.topicBreakingNews);
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotif.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: BigTextStyleInformation(
            notification.body ?? '',
            contentTitle: notification.title,
          ),
        ),
      ),
    );
  }
}
