import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class DeleteFileUsecase implements UseCase<Unit, String> {
  DeleteFileUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, Unit>> call(String documentId) async =>
      _storageRepository.deleteFile(documentId: documentId);
}
