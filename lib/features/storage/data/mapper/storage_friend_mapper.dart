import 'package:uit_buddy_mobile/features/storage/data/models/storage_friend_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/storage_friend_entity.dart';

extension StorageFriendMapper on StorageFriendModel {
  StorageFriendEntity toEntity() => StorageFriendEntity(
    id: id,
    name: name,
    mssv: mssv,
    avatarUrl: avatarUrl ?? '',
    createdAt: createdAt,
  );
}
