import 'package:fpdart/fpdart.dart';
import 'package:uit_buddy_mobile/core/error/failures.dart';
import 'package:uit_buddy_mobile/core/usecase/usecase_interface.dart';
import 'package:uit_buddy_mobile/features/profile/domain/entities/your_info_entity.dart';
import 'package:uit_buddy_mobile/features/profile/domain/repositories/your_info_repository.dart';

class UpdateYourInfoUsecase implements UseCase<YourInfoEntity, YourInfoEntity> {
  UpdateYourInfoUsecase({required YourInfoRepository repository})
    : _repository = repository;
  final YourInfoRepository _repository;

  @override
  Future<Either<Failure, YourInfoEntity>> call(YourInfoEntity params) async =>
      _repository.updateYourInfo(params);
}
