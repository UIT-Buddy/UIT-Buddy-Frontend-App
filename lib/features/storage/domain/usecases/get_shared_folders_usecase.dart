import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class GetSharedFoldersUsecase implements UseCase<List<FolderEntity>, NoParams> {
  GetSharedFoldersUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;

  final StorageRepository _storageRepository;

  @override
  Future<Either<Failure, List<FolderEntity>>> call(NoParams params) async =>
      _storageRepository.getSharedFolders();
}
