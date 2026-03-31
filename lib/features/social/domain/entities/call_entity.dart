import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_entity.freezed.dart';
part 'call_entity.g.dart';

enum CallStatus {
  @JsonValue('initiated')
  initiated,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('accepted')
  accepted,
  @JsonValue('rejected')
  rejected,
  @JsonValue('ended')
  ended,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('busy')
  busy,
  @JsonValue('unanswered')
  unanswered,
}

enum CallType { audio, video }

@freezed
abstract class CallEntity with _$CallEntity {
  const factory CallEntity({
    required String sessionId,
    @Default(CallStatus.initiated) CallStatus callStatus,
    @Default(CallType.audio) CallType callType,
    required String receiverId,
    @Default('') String receiverName,
    String? receiverAvatar,
    required String senderId,
    @Default('') String senderName,
    String? senderAvatar,
    DateTime? initiatedAt,
  }) = _CallEntity;

  factory CallEntity.fromJson(Map<String, dynamic> json) =>
      _$CallEntityFromJson(json);
}
