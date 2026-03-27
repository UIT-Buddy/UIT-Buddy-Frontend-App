import 'package:freezed_annotation/freezed_annotation.dart';

part 'comet_user_entity.freezed.dart';
part 'comet_user_entity.g.dart';

@freezed
abstract class CometUserEntity with _$CometUserEntity {
  const factory CometUserEntity({
    required String uid,
    required String name,
    String? avatar,
    String? link,
    String? role,
    String? status,
    String? statusMessage,
    DateTime? lastActiveAt,
    List<String>? tags,
    bool? hasBlockedMe,
    bool? blockedByMe,
  }) = _CometUserEntity;

  factory CometUserEntity.fromJson(Map<String, dynamic> json) =>
      _$CometUserEntityFromJson(json);
}
