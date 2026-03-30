import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';

abstract interface class StorageRepository {
  Future<Either<Failure, FolderEntity>> getFolder({String? folderId});

  Future<Either<Failure, Unit>> createFolder({
    required String folderName,
    String? parentFolderId,
  });

  Future<Either<Failure, Unit>> createFiles({
    required List<FileEntity> files,
    String? folderId,
  });

  Future<Either<Failure, List<FileEntity>>> searchDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    String keyword,
  });

  Future<Either<Failure, String>> getDownloadUrl({required String fileId});
}
