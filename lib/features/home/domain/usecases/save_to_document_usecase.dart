import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/note_repository.dart';

class SaveToDocumentParams {
  SaveToDocumentParams({required this.fileName, required this.folderId});

  final String fileName;
  final String folderId;
}

class SaveToDocumentUsecase implements UseCase<String, SaveToDocumentParams> {
  SaveToDocumentUsecase({required NoteRepository repository})
    : _repository = repository;

  final NoteRepository _repository;

  @override
  Future<Either<Failure, String>> call(SaveToDocumentParams params) =>
      _repository.saveToDocument(params.fileName, params.folderId);
}
