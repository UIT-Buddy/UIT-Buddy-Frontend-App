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
    required String sessionId,
    required String receiverId,
    required String receiverName,
    @Default('') String receiverAvatar,
  }) = CallOutgoing;

  /// Incoming call received — display accept/reject UI.
  const factory CallState.incoming({required CallEntity incomingCall}) =
      CallIncoming;

  /// Call was accepted — generating token and starting session.
  const factory CallState.connecting({
    required String receiverId,
    required String receiverName,
    @Default('') String receiverAvatar,
  }) = CallConnecting;

  /// Active call session in progress.
  const factory CallState.active({
    required String sessionId,
    required String receiverId,
    required String receiverName,
    @Default('') String receiverAvatar,
    required List<String> participantNames,
    required bool isMuted,
    required bool sessionWidgetReady,
  }) = CallActive;

  /// Call just ended — brief display state before returning to idle.
  const factory CallState.ended({
    required String receiverName,
    required int durationSeconds,
    required String receiverId,
    @Default('') String receiverAvatar,
  }) = CallEnded;

  /// An error occurred.
  const factory CallState.error({required String message}) = CallError;
}
