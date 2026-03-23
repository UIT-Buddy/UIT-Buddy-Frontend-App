import 'package:uit_buddy_mobile/features/profile/data/models/group_model.dart'
    as model;
import 'package:uit_buddy_mobile/features/profile/domain/entities/group_entity.dart'
    as entity;

extension GroupModelMapper on model.GroupModel {
  entity.GroupEntity toEntity() => entity.GroupEntity(
    id: id,
    name: name,
    description: description,
    avatarUrl: avatarUrl,
  );
}
