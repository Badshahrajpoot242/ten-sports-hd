// lib/services/firebase_service.dart
/// Firebase Service - Ready to Connect
/// 
/// HOW TO ACTIVATE FIREBASE:
/// 1. Run: flutterfire configure (install FlutterFire CLI first)
/// 2. Uncomment imports below
/// 3. Uncomment firebase_core & other deps in pubspec.yaml
/// 4. Call FirebaseService.initialize() in main.dart
/// 5. Switch DataService to use fetchCategoriesFromFirebase()

// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../firebase_options.dart';
// import '../models/category_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  static Future<void> initialize() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // await _setupFCM();
  }

  // ── Firestore: Categories ─────────────────────────────────
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    // final snapshot = await FirebaseFirestore.instance
    //     .collection('categories')
    //     .orderBy('sortOrder')
    //     .get();
    // return snapshot.docs.map((doc) => doc.data()).toList();
    return [];
  }

  // ── Firestore: Notifications ──────────────────────────────
  Stream<List<Map<String, dynamic>>> notificationsStream() {
    // return FirebaseFirestore.instance
    //     .collection('notifications')
    //     .orderBy('timestamp', descending: true)
    //     .limit(50)
    //     .snapshots()
    //     .map((s) => s.docs.map((d) => d.data()).toList());
    return Stream.value([]);
  }

  // ── FCM: Push Notifications ───────────────────────────────
  static Future<void> _setupFCM() async {
    // final fcm = FirebaseMessaging.instance;
    // await fcm.requestPermission(alert: true, badge: true, sound: true);
    // final token = await fcm.getToken();
    // print('FCM Token: $token');
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   // Handle foreground notifications
    // });
  }

  Future<String?> getFCMToken() async {
    // return await FirebaseMessaging.instance.getToken();
    return null;
  }
}
