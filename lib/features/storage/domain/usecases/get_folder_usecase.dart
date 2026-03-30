import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class GetFolderUsecase implements UseCase<FolderEntity, String> {
  GetFolderUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, FolderEntity>> call(String? folderId) async =>
      _storageRepository.getFolder(folderId: folderId);
}
