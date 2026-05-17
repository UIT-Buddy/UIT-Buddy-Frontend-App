import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class AIChatRepository {
  Future<Either<Failure, String>> sendMessage(String message);
}
