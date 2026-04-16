import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class ShareResourceUsecase implements UseCase<Unit, ShareResourceParams> {
  ShareResourceUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;

  @override
  Future<Either<Failure, Unit>> call(ShareResourceParams params) async =>
      _storageRepository.shareResource(
        resourceType: params.resourceType,
        resourceId: params.resourceId,
        targetMssv: params.targetMssv,
      );
}

class ShareResourceParams extends Equatable {
  const ShareResourceParams({
    required this.resourceType,
    required this.resourceId,
    required this.targetMssv,
  });

  final String resourceType;
  final String resourceId;
  final String targetMssv;

  @override
  List<Object?> get props => [resourceType, resourceId, targetMssv];
}
