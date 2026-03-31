import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/call_entity.dart';

part 'call_state.freezed.dart';

@freezed
abstract class CallState with _$CallState {
  const CallState._();

  /// No active call. The default/idle state.
  const factory CallState.idle() = CallIdle;

  /// Outgoing call initiated — waiting for the receiver to accept.
  const factory CallState.outgoing({
    required String receiverId,
    required String receiverName,
  }) = CallOutgoing;

  /// Incoming call received — display accept/reject UI.
  const factory CallState.incoming({required CallEntity incomingCall}) =
      CallIncoming;

  /// Call was accepted — generating token and starting session.
  const factory CallState.connecting({
    required String receiverId,
    required String receiverName,
  }) = CallConnecting;

  /// Active call session in progress.
  const factory CallState.active({
    required String sessionId,
    required String receiverId,
    required String receiverName,
    required List<String> participantNames,
    required bool isMuted,
    // The widget returned by CometChatCalls.startSession — rendered by the UI
    // as an overlay. Null until the session starts.
    required bool sessionWidgetReady,
  }) = CallActive;

  /// Call just ended — brief display state before returning to idle.
  const factory CallState.ended({required String receiverName}) = CallEnded;

  /// An error occurred.
  const factory CallState.error({required String message}) = CallError;
}
