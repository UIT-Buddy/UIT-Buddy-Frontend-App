import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/social/data/datasources/reaction_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/social/domain/repositories/reaction_repository.dart';

class ReactionRepositoryImpl implements ReactionRepository {
  ReactionRepositoryImpl({required ReactionDatasourceInterface datasource})
    : _datasource = datasource;

  final ReactionDatasourceInterface _datasource;

  @override
  Future<Either<Failure, Unit>> togglePostLike(String postId) async {
    try {
      await _datasource.togglePostLike(postId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleCommentLike(String commentId) async {
    try {
      await _datasource.toggleCommentLike(commentId);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
