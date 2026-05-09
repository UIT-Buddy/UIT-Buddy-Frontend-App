import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/note_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/note_repository.dart';

class GetNoteUsecase implements UseCase<NoteEntity, NoParams> {
  GetNoteUsecase({required NoteRepository repository})
    : _repository = repository;

  final NoteRepository _repository;

  @override
  Future<Either<Failure, NoteEntity>> call(NoParams params) =>
      _repository.getNote();
}
