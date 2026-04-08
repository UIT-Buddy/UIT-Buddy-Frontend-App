import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class DeleteAccountDatasourceInterface {
  Future<Either<Failure, void>> deleteAccount();
}
