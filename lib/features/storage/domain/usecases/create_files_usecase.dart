import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class CreateFilesUsecase implements UseCase<Unit, CreateFilesParams> {
  CreateFilesUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, Unit>> call(CreateFilesParams params) async =>
      _storageRepository.createFiles(
        files: params.files,
        folderId: params.folderId,
      );
}

class CreateFilesParams extends Equatable {
  final List<FileEntity> files;
  final String? folderId;

  const CreateFilesParams({required this.files, this.folderId});

  @override
  List<Object?> get props => [files, folderId];
}
