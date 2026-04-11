import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

@freezed
abstract class FriendModel with _$FriendModel {
  const factory FriendModel({
    required String id,
    required String name,
    required String mssv,
    String? avatarUrl,
    required DateTime createdAt,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}
