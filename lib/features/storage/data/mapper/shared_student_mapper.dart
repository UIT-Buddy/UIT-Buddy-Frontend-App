import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/shared_student_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/shared_student_entity.dart';

extension SharedStudentMapper on SharedStudentModel {
  SharedStudentEntity toEntity() => SharedStudentEntity(
    student: StudentEntity(
      fullName: student.fullName,
      mssv: student.mssv,
      avatarUrl: student.avatarUrl ?? '',
      email: student.email,
    ),
    accessRole: _mapAccessRole(accessRole),
    sharedAt: sharedAt,
  );
}

extension SharedStudentPagedResultMapper on PagedResult<SharedStudentModel> {
  PagedResult<SharedStudentEntity> toEntity() =>
      PagedResult<SharedStudentEntity>(
        items: items.map((item) => item.toEntity()).toList(),
        nextCursor: nextCursor,
        hasMore: hasMore,
      );
}

AccessRole _mapAccessRole(String role) {
  switch (role.toUpperCase()) {
    case 'OWNER':
      return AccessRole.owner;
    case 'VIEWER':
    default:
      return AccessRole.viewer;
  }
}
