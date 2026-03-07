import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/data/datasources/document_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/storage/data/mapper/document_mapper.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/document_repository.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl({
    required DocumentDatasourceInterface documentDatasourceInterface,
  }) : _documentDatasourceInterface = documentDatasourceInterface;

  final DocumentDatasourceInterface _documentDatasourceInterface;

  @override
  Future<Either<Failure, DocumentListEntity>> getFiles({
    required String classCode,
  }) async {
    try {
      final response = await _documentDatasourceInterface.getFiles(
        classCode: classCode,
      );
      if (response.data == null) {
        return Left(Failure(response.message));
      }
      return Right(response.data!.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
