import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class GetDownloadUrlUsecase implements UseCase<String, String> {
  GetDownloadUrlUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, String>> call(String fileId) async =>
      _storageRepository.getDownloadUrl(fileId: fileId);
}
