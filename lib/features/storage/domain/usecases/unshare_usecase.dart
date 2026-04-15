import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class UnshareUsecase implements UseCase<Unit, UnshareParams> {
  UnshareUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, Unit>> call(UnshareParams params) async =>
      _storageRepository.unShare(
        resourceId: params.resourceId,
        resourceType: params.resourceType,
        targetMssv: params.targetMssv,
      );
}

class UnshareParams extends Equatable {
  final String resourceId;
  final String resourceType;
  final String targetMssv;

  const UnshareParams({
    required this.resourceId,
    required this.resourceType,
    required this.targetMssv,
  });

  @override
  List<Object?> get props => [resourceId, resourceType, targetMssv];
}
