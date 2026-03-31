import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class CreateFolderUsecase implements UseCase<Unit, CreateFolderParams> {
  CreateFolderUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, Unit>> call(CreateFolderParams params) async =>
      _storageRepository.createFolder(
        folderName: params.folderName,
        parentFolderId: params.parentFolderId,
      );
}

class CreateFolderParams extends Equatable {
  final String folderName;
  final String? parentFolderId;

  const CreateFolderParams({required this.folderName, this.parentFolderId});

  @override
  List<Object?> get props => [folderName, parentFolderId];
}
