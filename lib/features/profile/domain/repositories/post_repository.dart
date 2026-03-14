import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/post_entity.dart';

abstract interface class PostRepository {
    Future<Either<Failure, List<PostEntity>>> getPosts();    
}