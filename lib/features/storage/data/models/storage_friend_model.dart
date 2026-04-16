import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_friend_model.freezed.dart';
part 'storage_friend_model.g.dart';

@freezed
abstract class StorageFriendModel with _$StorageFriendModel {
  const factory StorageFriendModel({
    required String id,
    required String name,
    required String mssv,
    String? avatarUrl,
    required DateTime createdAt,
  }) = _StorageFriendModel;

  factory StorageFriendModel.fromJson(Map<String, dynamic> json) =>
      _$StorageFriendModelFromJson(json);
}
