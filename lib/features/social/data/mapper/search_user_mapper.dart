import 'package:uit_buddy_mobile/features/social/data/models/search_user_model.dart';
import 'package:uit_buddy_mobile/features/social/domain/entities/search_user_entity.dart';

extension SearchUserModelMapper on SearchUserModel {
  SearchUserEntity toEntity() =>
      SearchUserEntity(mssv: mssv, fullName: fullName, avatarUrl: avatarUrl);
}
