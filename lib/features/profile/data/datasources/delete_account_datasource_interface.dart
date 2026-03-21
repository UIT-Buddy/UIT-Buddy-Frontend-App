import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class DeleteAccountDatasource {
  Future<Either<Failure, void>> deleteAccount();
}
