import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, void>> deleteAccount();
}
