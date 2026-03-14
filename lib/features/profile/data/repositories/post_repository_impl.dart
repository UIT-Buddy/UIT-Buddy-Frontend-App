import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/data/datasources/post_datasource_interface.dart';
import 'package:uit_buddy_mobile/features/profile/data/mapper/post_mapper.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl({required PostDatasourceInterface postDatasourceInterface})
      : _postDatasource = postDatasourceInterface;

  final PostDatasourceInterface _postDatasource;

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final response = await _postDatasource.getPosts();
      if (response.data == null) {
        return Left(Failure(response.message ?? 'Failed to load posts'));
      }
      return Right(response.data!.map((m) => m.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
