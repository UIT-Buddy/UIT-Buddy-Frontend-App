import 'dart:developer';
import 'dart:io';

import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';
import 'package:uit_buddy_mobile/features/chat/services/chat_service.dart';
import 'package:uit_buddy_mobile/features/chat/services/in_app_notification_service.dart';
import 'package:uit_buddy_mobile/features/onboarding/domain/repositories/firebase_repository.dart';

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _fm = FirebaseMessaging.instance;
  bool _isRegistered = false;
  bool _tokenRefreshListening = false;

  /// Request notification permission (iOS only, no-op on Android) and register
  /// FCM token with CometChat. Also starts in-app notification listener.
  /// Called from SessionBloc after successful sign-in.
  Future<void> registerAfterChatLogin() async {
    // 1. Request notification permission (no-op on Android)
    final firebaseRepo = GetIt.I<FirebaseRepository>();
    await firebaseRepo.requestPermission();

    // 2. Start in-app notification banner listener
    InAppNotificationService().startListening();

    // 3. Set up token refresh listener (only once)
    if (!_tokenRefreshListening) {
      _fm.onTokenRefresh.listen(_onTokenRefresh);
      _tokenRefreshListening = true;
    }

    // 4. Register current token with CometChat
    final token = await _fm.getToken();
    if (token != null) {
      await _registerToken(token);
    }
  }

  void _onTokenRefresh(String token) async {
    final chatService = GetIt.I<ChatService>();
    if (!chatService.isLoggedIn) return;
    await _registerToken(token);
  }

  Future<void> _registerToken(String token) async {
    final chatService = GetIt.I<ChatService>();
    if (!chatService.isLoggedIn) return;
    try {
      final platform = _getPushPlatform();
      await CometChatNotifications.registerPushToken(
        platform,
        providerId: AppEnv.cometChatProviderId,
        fcmToken: Platform.isAndroid ? token : null,
        deviceToken: !Platform.isAndroid ? token : null,
        onSuccess: (res) => log('[PushNotification] Registered: $res'),
        onError: (e) => log('[PushNotification] Register error: $e'),
      );
      _isRegistered = true;
      log('[PushNotification] FCM token registered with CometChat');
    } catch (e) {
      log('[PushNotification] Register exception: $e');
    }
  }

  /// Unregister FCM token from CometChat. Called on logout.
  Future<void> unregister() async {
    if (!_isRegistered) return;
    try {
      await CometChatNotifications.unregisterPushToken(
        onSuccess: (_) => log('[PushNotification] Unregistered'),
        onError: (e) => log('[PushNotification] Unregister error: $e'),
      );
      _isRegistered = false;
    } catch (e) {
      log('[PushNotification] Unregister exception: $e');
    }
  }

  PushPlatforms _getPushPlatform() {
    if (Platform.isAndroid) {
      return PushPlatforms.FCM_FLUTTER_ANDROID;
    } else {
      return PushPlatforms.FCM_FLUTTER_IOS;
    }
  }
}
