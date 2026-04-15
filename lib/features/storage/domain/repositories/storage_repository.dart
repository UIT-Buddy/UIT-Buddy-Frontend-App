import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/shared_student_entity.dart';

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

  Future<Either<Failure, Unit>> updateFile({
    required String documentId,
    required String fileName,
    String? folderId,
  });

  Future<Either<Failure, Unit>> shareResource({
    required String resourceType,
    required String resourceId,
    required String targetMssv,
  });

  Future<Either<Failure, PagedResult<SharedStudentEntity>>> getSharedUsers({
    required String resourceType,
    required String resourceId,
    int page = 1,
    int limit = 15,
    String sortType = 'desc',
    String sortBy = 'sharedAt',
  });

  Future<Either<Failure, Unit>> deleteFile({required String documentId});

  Future<Either<Failure, Unit>> unShare({
    required String resourceId,
    required String resourceType,
    required String targetMssv,
  });

  Future<Either<Failure, List<FileEntity>>> searchSharedDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    String keyword,
  });
}
