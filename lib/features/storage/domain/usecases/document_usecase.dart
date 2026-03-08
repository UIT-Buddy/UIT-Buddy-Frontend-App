import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/storage/domain/entities/document_entity.dart';
import 'package:uit_buddy_mobile/features/storage/domain/repositories/document_repository.dart';

class DocumentUsecase implements UseCase<DocumentListEntity, DocumentParams> {
  DocumentUsecase({required DocumentRepository documentRepository})
    : _documentRepository = documentRepository;
  final DocumentRepository _documentRepository;
  @override
  Future<Either<Failure, DocumentListEntity>> call(
    DocumentParams params,
  ) async => _documentRepository.getFiles(classCode: params.classCode);
}

@immutable
class DocumentParams extends Equatable {
  const DocumentParams({required this.classCode});
  final String classCode;
  @override
  List<Object?> get props => [classCode];
}
