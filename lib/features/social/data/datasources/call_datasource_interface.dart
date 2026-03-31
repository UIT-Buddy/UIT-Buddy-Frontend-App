import 'package:cometchat_calls_sdk/cometchat_calls_sdk.dart' hide CallEntity;
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';

abstract interface class CallDatasourceInterface {
  /// Initiate an outgoing call to [receiverId].
  /// Returns the initiated [CallEntity] wrapped in a Future.
  Future<CallEntity> initiateCall({
    required String receiverId,
    required bool isGroup,
  });

  /// Accept an incoming call identified by [sessionId].
  Future<CallEntity> acceptCall(String sessionId);

  /// Reject an incoming call. Set [busy] to true to send BUSY status.
  Future<void> rejectCall(String sessionId, {bool busy = false});

  /// End an active call.
  Future<void> endCall(String sessionId);

  /// Cancel the most recent pending outgoing call.
  /// Uses [pendingSessionId] internally.
  Future<void> cancelOutgoingCall();

  /// Clear the active call from local state.
  void clearActiveCall();

  /// Get the user's CometChat auth token (for call token generation).
  Future<String> getUserAuthToken();

  /// Generate a call token for starting a call session.
  Future<GenerateToken> generateCallToken({
    required String sessionId,
    required String authToken,
  });

  /// Start a call session with the generated token.
  /// The [listener] should implement [CometChatCallsEventsListener].
  void startCallSession({
    required GenerateToken token,
    required CallSettings callSettings,
  });

  /// End the active call session.
  Future<void> endCallSession();

  /// Register a CometChatCalls event listener with the given [listenerId].
  void addCallsEventListener(
    String listenerId,
    CometChatCallsEventsListener listener,
  );

  /// Remove a CometChatCalls event listener.
  void removeCallsEventListener(String listenerId);

  /// Returns the most recently initiated call's sessionId,
  /// or empty string if none. Used by the bloc to cancel a pending outgoing call.
  String get pendingSessionId;
}
