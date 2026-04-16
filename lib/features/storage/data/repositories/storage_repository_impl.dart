import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/common/paged_result.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/file_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/folder_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/shared_student_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/shared_student_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  StorageRepositoryImpl({
    required StorageDatasourceInterface storageDatasourceInterface,
  }) : _storageDatasourceInterface = storageDatasourceInterface;

  final StorageDatasourceInterface _storageDatasourceInterface;

  @override
  Future<Either<Failure, FolderEntity>> getFolder({String? folderId}) async {
    try {
      final response = await _storageDatasourceInterface.getFolder(folderId);
      return Right(response.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> createFolder({
    required String folderName,
    String? parentFolderId,
  }) async {
    try {
      await _storageDatasourceInterface.createFolder(
        folderName: folderName,
        parentFolderId: parentFolderId,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> createFiles({
    required List<FileEntity> files,
    String? folderId,
  }) async {
    try {
      // Convert FileEntity back to FileModel for datasource
      final fileModels = files
          .map(
            (f) => FileModel(
              id: f.id,
              name: f.name,
              url: f.url,
              size: f.size,
              sizeUnit: f.sizeUnit,
              type: f.type.toString().split('.').last,
            ),
          )
          .toList();

      await _storageDatasourceInterface.createFiles(
        files: fileModels,
        folderId: folderId,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> searchDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    String keyword = '',
  }) async {
    try {
      final response = await _storageDatasourceInterface.searchDocuments(
        page: page,
        limit: limit,
        sortType: sortType,
        sortBy: sortBy,
        keyword: keyword,
      );
      return Right(response.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl({
    required String fileId,
  }) async {
    try {
      final url = await _storageDatasourceInterface.getDownloadUrl(fileId);
      return Right(url);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateFile({
    required String documentId,
    required String fileName,
    String? folderId,
  }) async {
    try {
      await _storageDatasourceInterface.updateFile(
        documentId: documentId,
        fileName: fileName,
        folderId: folderId,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> shareResource({
    required String resourceType,
    required String resourceId,
    required String targetMssv,
  }) async {
    try {
      await _storageDatasourceInterface.shareResource(
        resourceType: resourceType,
        resourceId: resourceId,
        targetMssv: targetMssv,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, PagedResult<SharedStudentEntity>>> getSharedUsers({
    required String resourceType,
    required String resourceId,
    int page = 1,
    int limit = 15,
    String sortType = 'desc',
    String sortBy = 'sharedAt',
  }) async {
    try {
      final response = await _storageDatasourceInterface.getSharedUsers(
        resourceType: resourceType,
        resourceId: resourceId,
        page: page,
        limit: limit,
        sortType: sortType,
        sortBy: sortBy,
      );

      return Right(response.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> unShare({
    required String resourceId,
    required String resourceType,
    required String targetMssv,
  }) async {
    try {
      await _storageDatasourceInterface.unShare(
        resourceId: resourceId,
        resourceType: resourceType,
        targetMssv: targetMssv,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteFile({required String documentId}) async {
    try {
      await _storageDatasourceInterface.deleteFile(documentId: documentId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<FileEntity>>> searchSharedDocuments({
    int? page,
    int? limit,
    String? sortType,
    String? sortBy,
    String keyword = '',
  }) async {
    try {
      final response = await _storageDatasourceInterface.searchSharedDocuments(
        page: page,
        limit: limit,
        sortType: sortType,
        sortBy: sortBy,
        keyword: keyword,
      );
      return Right(response.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
