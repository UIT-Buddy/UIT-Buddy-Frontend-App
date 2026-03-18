import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract interface class FirebaseRemoteDatasource {
  Future<void> init();
  Future<bool> requestPermission();
  Future<String?> getFcmToken();
  Stream<String?> onTokenRefresh();
}

class FirebaseRemoteDatasourceImpl implements FirebaseRemoteDatasource {
  final FirebaseMessaging _firebaseMessaging;

  FirebaseRemoteDatasourceImpl(this._firebaseMessaging);

  @override
  Future<void> init() async {
    await Firebase.initializeApp();
  }

  @override
  Future<bool> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging
        .requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('[FCM] Retrieved token: $token');
      return token ?? '';
    } catch (e, s) {
      log('[FCM] Failed to get token: $e', error: e, stackTrace: s);
      return '';
    }
  }

  @override
  Stream<String?> onTokenRefresh() {
    return _firebaseMessaging.onTokenRefresh;
  }
}
