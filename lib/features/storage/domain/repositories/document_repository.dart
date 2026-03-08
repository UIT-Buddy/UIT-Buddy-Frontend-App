import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';

abstract interface class DocumentRepository {
  Future<Either<Failure, DocumentListEntity>> getFiles({
    required String classCode, 
  });
}