import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/shared_student_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class GetSharedUsersUsecase
    implements UseCase<PagedResult<SharedStudentEntity>, GetSharedUsersParams> {
  GetSharedUsersUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;

  @override
  Future<Either<Failure, PagedResult<SharedStudentEntity>>> call(
    GetSharedUsersParams params,
  ) async => _storageRepository.getSharedUsers(
    resourceType: params.resourceType,
    resourceId: params.resourceId,
    page: params.page,
    limit: params.limit,
    sortType: params.sortType,
    sortBy: params.sortBy,
  );
}

class GetSharedUsersParams extends Equatable {
  const GetSharedUsersParams({
    required this.resourceType,
    required this.resourceId,
    this.page = 1,
    this.limit = 15,
    this.sortType = 'desc',
    this.sortBy = 'sharedAt',
  });

  final String resourceType;
  final String resourceId;
  final int page;
  final int limit;
  final String sortType;
  final String sortBy;

  @override
  List<Object?> get props => [
    resourceType,
    resourceId,
    page,
    limit,
    sortType,
    sortBy,
  ];
}
