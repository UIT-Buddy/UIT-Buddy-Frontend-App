import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    final uiKitSettings = (UIKitSettingsBuilder()
      ..subscriptionType = CometChatSubscriptionType.allUsers
      ..region = AppEnv.cometChatRegion
      ..autoEstablishSocketConnection = true
      ..appId = AppEnv.cometChatAppId
      ..callingExtension = null
      ..extensions = CometChatUIKitChatExtensions.getDefaultExtensions()
      ..aiFeature = null)
        .build();

    await CometChatUIKit.init(
      uiKitSettings: uiKitSettings,
      onSuccess: (successMessage) {
        debugPrint('CometChat initialized successfully');
        _isInitialized = true;
      },
      onError: (e) {
        debugPrint('CometChat init error: $e');
      },
    );
  }

  Future<bool> login(String uid, {String? name, String? avatar}) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      final user = await CometChatUIKit.login(
        uid,
        onSuccess: (user) {
          debugPrint('CometChat login success: ${user.uid}');
          return true;
        },
        onError: (e) {
          debugPrint('CometChat login error: $e');
          return false;
        },
      );
      return user != null;
    } catch (e) {
      debugPrint('CometChat login exception: $e');
      return false;
    }
  }

  Future<void> logout({VoidCallback? onSuccess}) async {
    try {
      await CometChatUIKit.logout(
        onSuccess: (msg) {
          debugPrint('CometChat logout success');
          onSuccess?.call();
        },
      );
    } catch (e) {
      debugPrint('CometChat logout error: $e');
    }
  }

  User? get currentUser => CometChatUIKit.loggedInUser;

  bool get isLoggedIn => currentUser != null;
}
