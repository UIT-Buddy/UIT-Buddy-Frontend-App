import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class UpdateFilesUsecase implements UseCase<Unit, UpdateFilesParams> {
  UpdateFilesUsecase({required StorageRepository storageRepository})
    : _storageRepository = storageRepository;
  final StorageRepository _storageRepository;
  @override
  Future<Either<Failure, Unit>> call(UpdateFilesParams params) async =>
      _storageRepository.updateFile(
        documentId: params.documentId,
        fileName: params.fileName,
        folderId: params.folderId,
      );
}

class UpdateFilesParams extends Equatable {
  final String fileName;
  final String? folderId;
  final String documentId;

  const UpdateFilesParams({
    required this.fileName,
    this.folderId,
    required this.documentId,
  });

  @override
  List<Object?> get props => [fileName, folderId, documentId];
}
