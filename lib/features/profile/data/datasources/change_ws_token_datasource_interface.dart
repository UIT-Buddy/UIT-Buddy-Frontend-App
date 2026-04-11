import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class ChangeWsTokenDatasourceInterface {
  Future<Either<Failure, void>> changeWsToken(String newToken);
}
