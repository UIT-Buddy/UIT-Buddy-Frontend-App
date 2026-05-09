import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/home/data/datasources/note_datasource.dart';
import 'package:uit_buddy_mobile/features/home/data/mapper/note_mapper.dart';
import 'package:uit_buddy_mobile/features/home/domain/entities/note_entity.dart';
import 'package:uit_buddy_mobile/features/home/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl({required NoteDatasource noteDatasource})
    : _noteDatasource = noteDatasource;

  final NoteDatasource _noteDatasource;

  @override
  Future<Either<Failure, NoteEntity>> getNote() async {
    try {
      final model = await _noteDatasource.getNote();
      return Right(model.toEntity());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> upsertNote(String content) async {
    try {
      await _noteDatasource.upsertNote(content);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
