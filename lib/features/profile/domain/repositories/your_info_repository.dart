import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';

abstract interface class YourInfoRepository {
  Future<Either<Failure, YourInfoEntity>> getYourInfo();
  Future<Either<Failure, YourInfoEntity>> updateYourInfo(YourInfoEntity yourInfo);
}