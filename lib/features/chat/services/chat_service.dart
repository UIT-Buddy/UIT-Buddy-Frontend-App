import 'package:cometchat_calls_uikit/cometchat_calls_uikit.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:uit_buddy_mobile/core/config/app_env.dart';
import 'package:uit_buddy_mobile/core/theme/app_color.dart';
import 'package:uit_buddy_mobile/features/chat/services/call_permission_service.dart';
import 'package:uit_buddy_mobile/features/chat/services/in_app_notification_service.dart';
import 'package:uit_buddy_mobile/features/chat/services/push_notification_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    final uiKitSettings =
        (UIKitSettingsBuilder()
              ..subscriptionType = CometChatSubscriptionType.allUsers
              ..region = AppEnv.cometChatRegion
              ..autoEstablishSocketConnection = true
              ..appId = AppEnv.cometChatAppId
              ..callingExtension = CometChatCallingExtension(
                configuration: _buildCallingConfiguration(),
              )
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

  CallingConfiguration _buildCallingConfiguration() {
    return CallingConfiguration(
      callButtonsConfiguration: CallButtonsConfiguration(
        callButtonsStyle: CometChatCallButtonsStyle(
          voiceCallButtonColor: AppColor.primaryBlue10,
          videoCallButtonColor: AppColor.primaryBlue10,
          voiceCallIconColor: AppColor.primaryBlue,
          videoCallIconColor: AppColor.primaryBlue,
        ),
      ),
      incomingCallConfiguration: CometChatIncomingCallConfiguration(
        incomingCallStyle: CometChatIncomingCallStyle(
          backgroundColor: AppColor.pureWhite,
          titleColor: AppColor.primaryText,
          subtitleColor: AppColor.secondaryText,
          acceptButtonColor: AppColor.successGreen,
          declineButtonColor: AppColor.alertRed,
        ),
      ),
      outgoingCallConfiguration: CometChatOutgoingCallConfiguration(
        outgoingCallStyle: CometChatOutgoingCallStyle(
          backgroundColor: AppColor.pureWhite,
          titleColor: AppColor.primaryText,
          subtitleColor: AppColor.secondaryText,
          declineButtonColor: AppColor.alertRed,
        ),
      ),
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
      // Stop in-app notification listener
      InAppNotificationService().stopListening();
      // Unregister FCM token from CometChat before logout
      GetIt.I<PushNotificationService>().unregister();
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

  /// Check and request call permissions (microphone + camera).
  /// Returns true if permissions are granted.
  /// Call this before initiating a call.
  Future<bool> checkAndRequestCallPermissions() async {
    final permissionService = GetIt.I<CallPermissionService>();
    return await permissionService.requestCallPermissions();
  }

  /// Request microphone permission only (for voice calls).
  Future<bool> requestMicrophonePermission() async {
    final permissionService = GetIt.I<CallPermissionService>();
    return await permissionService.requestMicrophonePermission();
  }

  /// Request camera permission only (for video calls).
  Future<bool> requestCameraPermission() async {
    final permissionService = GetIt.I<CallPermissionService>();
    return await permissionService.requestCameraPermission();
  }

  /// Open app settings for manually granting permissions.
  Future<bool> openPermissionSettings() async {
    final permissionService = GetIt.I<CallPermissionService>();
    return await permissionService.openSettings();
  }
}
