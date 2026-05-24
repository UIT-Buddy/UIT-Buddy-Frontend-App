import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/note_entity.dart';

abstract interface class NoteRepository {
  Future<Either<Failure, NoteEntity>> getNote();
  Future<Either<Failure, void>> upsertNote(String content);
  Future<Either<Failure, void>> newNote();
  Future<Either<Failure, String>> saveToDocument(
    String fileName,
    String folderId,
  );
}
