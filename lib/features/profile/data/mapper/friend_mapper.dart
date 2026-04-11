import 'package:uit_buddy_mobile/features/profile/data/models/friend_model.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/friend_entity.dart';

extension FriendModelMapper on FriendModel {
  FriendEntity toEntity() => FriendEntity(
    id: id,
    name: name,
    mssv: mssv,
    avatarUrl: avatarUrl ?? "",
    createdAt: createdAt,
  );
}
