import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/note_repository.dart';

class UpsertNoteUsecase implements UseCase<void, String> {
  UpsertNoteUsecase({required NoteRepository repository})
    : _repository = repository;

  final NoteRepository _repository;

  @override
  Future<Either<Failure, void>> call(String params) =>
      _repository.upsertNote(params);
}
