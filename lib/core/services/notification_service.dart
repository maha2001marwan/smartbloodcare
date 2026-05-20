import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _saveMessageToFirestore(message);
}

Future<void> _saveMessageToFirestore(RemoteMessage message) async {
  try {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': message.notification?.title ?? message.data['title'] ?? 'إشعار جديد',
      'body': message.notification?.body ?? message.data['body'] ?? '',
      'type': message.data['type'] ?? 'general',
      'bloodType': message.data['bloodType'] ?? '',
      'requestId': message.data['requestId'] ?? '',
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    print('Error saving notification to Firestore: $e');
  }
}

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    try {
      // Request permission safely
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      ).timeout(const Duration(seconds: 5), onTimeout: () => throw 'FCM Permission Timeout');

      // Initialize local notifications
      const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(android: androidInit);
      
      await _localNotifications.initialize(initSettings).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('Local Notifications Init Timeout');
          return false;
        },
      );

      // Listeners
      FirebaseMessaging.onMessage.listen((message) {
        _saveMessageToFirestore(message);
        _showLocalNotification(message);
      });

      // When user taps notification while app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        _saveMessageToFirestore(message);
      });

      // When app is opened from a terminated state via notification
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _saveMessageToFirestore(initialMessage);
      }

      // Log FCM device token
      _logToken();
    } catch (e) {
      print("Notification Service Init Error: $e");
    }

    return this;
  }

  // Subscribe to blood type topic (e.g. donors_A_pos)
  Future<void> subscribeToBloodType(String bloodType) async {
    try {
      String topic = 'donors_${bloodType.replaceAll('+', '_pos').replaceAll('-', '_neg')}';
      await _fcm.subscribeToTopic(topic);
      await _fcm.subscribeToTopic('all_donors');
      print("Subscribed to topic: $topic");
    } catch (e) {
      print("Error subscribing to topic: $e");
    }
  }

  Future<void> unsubscribeFromBloodType(String bloodType) async {
    String topic = 'donors_${bloodType.replaceAll('+', '_pos').replaceAll('-', '_neg')}';
    await _fcm.unsubscribeFromTopic(topic);
  }

  Future<void> _logToken() async {
    try {
      final token = await _fcm.getToken();
      print('═══════════════════════════════════════════');
      print('🔥 FCM TOKEN: $token');
      print('═══════════════════════════════════════════');
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'blood_bank_channel',
      'Blood Bank Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? message.data['title'] ?? "تنبيه جديد",
      message.notification?.body ?? message.data['body'] ?? "لديك رسالة جديدة من بنك الدم",
      details,
    );
  }
}
