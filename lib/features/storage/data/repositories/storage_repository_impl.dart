import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/storage_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/file_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/folder_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/data/models/file_model.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/file_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/folder_entity.dart';
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
}
